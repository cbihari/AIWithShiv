#!/usr/bin/env node
import {execFileSync} from "node:child_process";
import http from "node:http";

const port = Number(process.env.PORT || 8787);
const keychainName = process.env.KEYCHAIN_SERVICE || "AIWITHSHIV_OPENAI_API_KEY";
const user = process.env.USER || "";

function readOpenAiKey() {
  const attempts = [
    ["find-generic-password", "-a", user, "-s", keychainName, "-w"],
    ["find-generic-password", "-s", keychainName, "-w"],
    ["find-generic-password", "-a", keychainName, "-w"],
    ["find-generic-password", "-l", keychainName, "-w"],
  ];

  for (const args of attempts) {
    try {
      const value = execFileSync("security", args, {
        encoding: "utf8",
        stdio: ["ignore", "pipe", "ignore"],
      }).trim();
      if (value) return value;
    } catch {
      // Try the next keychain lookup shape.
    }
  }

  throw new Error(`Keychain item not found: ${keychainName}`);
}

function systemPrompt(ageGroup) {
  return [
    "You are ShivBot, a friendly robot-superhero boy.",
    `Audience: Indian kids aged 5-10. Age group: ${ageGroup || "kids"}.`,
    "Use simple English with occasional Hindi words like Namaste, Shabash, Masti, Dost, Chalo.",
    "Reply in max 3 short sentences.",
    "Use child-safe examples: tiffin, cricket, Diwali, mango, school, family.",
    "No scary, adult, political, violent, hateful, unsafe, or private-data content.",
    "Always encourage the child and stay playful.",
  ].join(" ");
}

function sendJson(response, status, payload) {
  response.writeHead(status, {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Content-Type": "application/json",
  });
  response.end(JSON.stringify(payload));
}

async function readBody(request) {
  const chunks = [];
  for await (const chunk of request) chunks.push(chunk);
  return Buffer.concat(chunks).toString("utf8");
}

const openAiKey = readOpenAiKey();

http
  .createServer(async (request, response) => {
    if (request.method === "OPTIONS") {
      sendJson(response, 204, {});
      return;
    }

    if (request.method !== "POST" || request.url !== "/askShivBot") {
      sendJson(response, 404, {error: "Not found"});
      return;
    }

    try {
      const body = JSON.parse(await readBody(request));
      const message = String(body.message || "").trim();
      const ageGroup = String(body.ageGroup || "kids").trim();

      if (!message || message.length > 1000) {
        sendJson(response, 400, {error: "Invalid message"});
        return;
      }

      const aiResponse = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${openAiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-4.1-mini",
          max_tokens: 150,
          temperature: 0.8,
          messages: [
            {role: "system", content: systemPrompt(ageGroup)},
            {role: "user", content: message},
          ],
        }),
      });

      if (!aiResponse.ok) {
        const details = await aiResponse.text();
        console.error(`OpenAI error ${aiResponse.status}: ${details}`);
        sendJson(response, 502, {error: "OpenAI request failed"});
        return;
      }

      const payload = await aiResponse.json();
      const reply = payload?.choices?.[0]?.message?.content?.trim();
      sendJson(response, 200, {
        reply:
          reply ||
          "Namaste dost! ShivBot needs one more try. Ask me again! ⚡",
      });
    } catch (error) {
      console.error(error);
      sendJson(response, 500, {error: "ShivBot proxy failed"});
    }
  })
  .listen(port, () => {
    console.log(`Local ShivBot proxy running at http://localhost:${port}`);
    console.log(`Using macOS Keychain item: ${keychainName}`);
  });
