/// <reference path="./types/fresh.d.ts" />
/// <reference path="./types/plugins.d.ts" />
const editor = getEditor();

// Fresh init.ts — decisions that depend on the environment at startup.
//
// init.ts is NOT for:
//   - Static preferences (tab size, line numbers, ...)  -> Settings UI
//   - Key bindings                                      -> Keybindings editor
//   - Themes you always want                            -> Theme selector
//   - Reusable features                                 -> A plugin package
//
// init.ts IS for things that:
//   - Depend on where/how Fresh is starting (host, SSH, $TERM, project, ...)
//   - Would differ across machines or launches
//   - Can't live in a shared config.json without lying to teammates
//
// API reference: ~/.config/fresh/types/fresh.d.ts (same as plugins)
// Commands:  Ctrl+P -> "init: Reload", "init: Check"
// CLI:       fresh --cmd init check | fresh --safe | fresh --no-init

// Example: fade the editor in from black to the target theme. Uses
// `overrideThemeColors` (in-memory, no disk I/O) for each frame, then
// calls `applyTheme` at the end to drop the overrides and land cleanly
// on the saved theme. `editor.delay(ms)` returns a Promise, so an async
// for-loop is all the timing machinery we need — no setInterval.
// (async () => {
//     const target = "one-dark";
//     const data = editor.getThemeData(target) as
//         | { editor?: Record<string, [number, number, number]> }
//         | null;
//     const bg = data?.editor?.bg ?? [30, 30, 30];
//     const fg = data?.editor?.fg ?? [220, 220, 220];
//     const frames = 18;
//     const stepMs = 16;
//     const lerp = (a: number, b: number, t: number) =>
//         Math.round(a + (b - a) * t);
//     for (let i = 1; i <= frames; i++) {
//         const t = i / frames;
//         editor.overrideThemeColors({
//             "editor.bg": [lerp(0, bg[0], t), lerp(0, bg[1], t), lerp(0, bg[2], t)],
//             "editor.fg": [lerp(0, fg[0], t), lerp(0, fg[1], t), lerp(0, fg[2], t)],
//         });
//         await editor.delay(stepMs);
//     }
//     editor.applyTheme(target); // drop overrides, settle on the real theme
// })();

// Example: calmer UI over SSH. setSetting writes to the runtime layer —
// nothing is persisted to disk, and removing this file is a complete undo.
// if (editor.getEnv("SSH_TTY")) {
//     editor.setSetting("editor.diagnostics_inline_text", false);
//     editor.setSetting("terminal.mouse", false);
// }

// Example: host-specific rust-analyzer path.
// if (editor.getEnv("HOSTNAME") === "my-mac") {
//     editor.registerLspServer("rust", {
//         command: "/opt/homebrew/bin/rust-analyzer",
//         args: [],
//         autoStart: true,
//         initializationOptions: null,
//         processLimits: null,
//     });
// }

// Example: env-driven profile (fresh invoked as FRESH_PROFILE=writing fresh).
// if (editor.getEnv("FRESH_PROFILE") === "writing") {
//     editor.setSetting("editor.line_wrap", true);
//     editor.setSetting("editor.wrap_column", 80);
// }

// Example: configure a plugin once it loads. `plugins_loaded` fires after
// every registry plugin and init.ts top-level code has run.
// editor.on("plugins_loaded", () => {
//     const api = editor.getPluginApi("my-plugin");
//     if (api) api.configure({ option: "value" });
// });

// Example: enable the opt-in Dashboard widgets (weather, GitHub).
// Both hit the network on every refresh, so the plugin ships with
// only `git` and `disk` registered by default. The handlers live
// on the exported plugin API as `builtinHandlers` — pass them to
// `registerSection` with whatever name you like.
//
// editor.on("plugins_loaded", () => {
//     const dash = editor.getPluginApi("dashboard");
//     if (!dash) return;
//     dash.registerSection("weather", dash.builtinHandlers.weather);
//     dash.registerSection("github", dash.builtinHandlers.github);
// });

// Example: disable the Dashboard's auto-open behaviour on this
// machine (it will still be available via the "Show Dashboard"
// command). The same toggle can also be set persistently in
// config.json at `plugins.dashboard.auto-open`.
//
// editor.on("plugins_loaded", () => {
//     const dash = editor.getPluginApi("dashboard");
//     if (dash) dash.setAutoOpen(false);
// });

// Example: add a custom section to the Dashboard plugin.
//
// `editor.getPluginApi("dashboard")` is typed automatically via
// `types/plugins.d.ts` — no `as` cast needed. Hover over `dash` or
// `ctx` in your editor to see the full API.
//
// editor.on("plugins_loaded", () => {
//     const dash = editor.getPluginApi("dashboard");
//     if (!dash) return;
//     dash.registerSection("todo", async (ctx) => {
//         // Pretend we read a TODO count from somewhere async.
//         const count = 3;
//         if (count === 0) {
//             ctx.kv("status", "inbox zero", "ok");
//             return;
//         }
//         ctx.kv("open", String(count), count > 5 ? "warn" : "value");
//         ctx.text("    " + "see all".padEnd(10), { color: "muted" });
//         ctx.text("open inbox", {
//             color: "accent",
//             bold: true,
//             onClick: () => editor.executeAction("open_inbox"),
//         });
//         ctx.newline();
//     });
// });
