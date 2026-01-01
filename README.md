<div align="center">

  <img src="/fancy.png" width="1500" height="500" alt="Fancy" />

A fancier shell scripting language

</div>

---

**Fancy** is a Crystal-based collection of command-line binaries that form a DSL-style shell scripting language. The language itself is called **Fancy**.

## Why Crystal?

Originally, **Fancy** was intended to be written in Ruby, but Ruby had cross-platform compilation issues. Crystal was chosen instead because it offers:

* Ruby-like syntax
* Native compilation
* Faster performance

---

## Binaries

**Fancy** includes multiple binaries that together enable a DSL-style shell scripting workflow:

| Binary       | Purpose / Vibe                                             | Usage                                                                            | Example                                             |
| ------------ | ---------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------- |
| **ask**      | Interactive user prompt                                    | `ask <prompt> [--default <value>] [--secret]`                                    | `ask "Enter name:" --default "guest"`               |
| **check**    | Preflight checks: binaries, env vars, files                | `check [--binary <name>] [--env <var>] [--file <path>]`                          | `check --binary ruby --env HOME --file config.json` |
| **clean**    | Remove temporary or generated files                        | `clean <pattern1> [pattern2] ...`                                                | `clean '*.tmp' 'build/' '.cache'`                   |
| **confirm**  | Yes/no prompt in scripts                                   | `confirm <prompt> [--yes\|--no]`                                                 | `confirm "Delete file?" --yes`                      |
| **copycat**  | Copy files (optional overwrite)                            | `copycat [--overwrite] <source> <dest>`                                          | `copycat config.json config.json.bak`               |
| **dump**     | Print structured info: env, configs, system                | `dump [--env\|--system\|--config <file>]`                                        | `dump --env` or `dump config.json`                  |
| **ensure**   | Ensure a file or folder exists; fail otherwise             | `ensure <file_path>`                                                             | `ensure config.json`                                |
| **envset**   | Check or set environment variables                         | `envset check <var1> [var2] ...` or `envset set <var> <value>`                   | `envset check HOME PATH`                            |
| **eq**       | Evaluate conditions / expressions and run commands if true | `eq EXPR <expression> THEN <command> [args...]`                                  | `eq EXPR "$USER == 'dennis'" THEN out "Yes"`        |
| **guard**    | Validate folder structure                                  | `guard path <path1> [path2] ...` or `guard structure <base> <path1> [path2] ...` | `guard path src/ lib/`                              |
| **hashit**   | Compute checksums / hashes for files                       | `hashit [--algorithm sha256\|md5] <file1> [file2] ...`                           | `hashit --md5 file.txt`                             |
| **manifest** | Verify a list of files exist                               | `manifest <file1> [file2] [file3] ...`                                           | `manifest index.html style.css script.js`           |
| **out**      | Output messages with status codes                          | `out <message> [code]`                                                           | `out "Success!" 1`                                  |
| **touchup**  | Create missing files or directories                        | `touchup <path1> [path2] [path3] ...`                                            | `touchup logs/app.log src/utils/`                   |
| **watch**    | Watch files/folders and run a command on change            | `watch <path> <command> [args...]`                                               | `watch src/ 'echo changed'`                         |

### Status Codes (`out`)

* `0` or empty: Plain output
* `1`: Success (green checkmark)
* `2`: Error (red symbol)
* `3`: Warning (yellow exclamation)
* `4`: Information (cyan info)

---

## Building

Compile binaries using the `justfile`:

```bash
just compile <binary_name>
# or
just c <binary_name>
```

Or manually with Crystal:

```bash
crystal build binaries/<binary>/source.cr -o binaries/<binary>/<binary>
rm binaries/<binary>/<binary>.dwarf
```

---

## License

MIT License, see [LICENSE file](LICENSE) for details.
