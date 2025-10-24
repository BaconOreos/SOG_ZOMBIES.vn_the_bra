#command prompt instructions
# navigate to: cd "C:\Users\Lucas Gretchko\Documents\Arma 3 - Other Profiles\Bacon%20Oreos\mpmissions\SOG_ZOMBIES.vn_the_bra"
# use "py generate_voicepacks.py" to start the generation

import os

# Paths
ROOT_DIR = r"C:\Users\Lucas Gretchko\Documents\Arma 3 - Other Profiles\Bacon%20Oreos\mpmissions\SOG_ZOMBIES.vn_the_bra\sounds"
VOICEPACKS_DIR = os.path.join(ROOT_DIR, "voicepacks")
OUTPUT_FILE = r"C:\Users\Lucas Gretchko\Documents\Arma 3 - Other Profiles\Bacon%20Oreos\mpmissions\SOG_ZOMBIES.vn_the_bra\voicepacks.hpp"

def sanitize_classname(name):
    """Remove or replace characters that break SQF classnames"""
    return name.replace("-", "_").replace(" ", "_").replace(".", "_")

def generate_cfgsounds():
    lines = []
    register_lines = []
    lines.append("class CfgSounds {")

    total_sounds = 0

    # --- Process root-level sounds (not in voicepacks)
    root_files = [f for f in os.listdir(ROOT_DIR) if f.lower().endswith(".ogg")]
    root_files.sort()

    if root_files:
        lines.append("    /*")
        lines.append("    Root sound effects")
        lines.append("    [" + ", ".join([sanitize_classname(os.path.splitext(f)[0]) for f in root_files]) + "]")
        lines.append("    */")

        for file in root_files:
            base_name = os.path.splitext(file)[0]
            class_name = sanitize_classname(base_name)
            rel_path = f"sounds\\{file}"
            lines.append(f"    class {class_name} {{")
            lines.append(f"        name = \"{class_name}\";")
            lines.append(f"        sound[] = {{\"{rel_path}\", 5, 1}};")
            lines.append("        titles[] = {};")
            lines.append("    };")
            total_sounds += 1

    # --- Process voicepacks
    pack_dirs = [d for d in os.listdir(VOICEPACKS_DIR) if os.path.isdir(os.path.join(VOICEPACKS_DIR, d))]
    pack_dirs.sort()

    for pack_name in pack_dirs:
        pack_path = os.path.join(VOICEPACKS_DIR, pack_name)
        print(f"Processing voice pack: {pack_name}")

        context_arrays = {}
        context_dirs = [d for d in os.listdir(pack_path) if os.path.isdir(os.path.join(pack_path, d))]
        context_dirs.sort()

        sound_count = 0
        for context_name in context_dirs:
            context_path = os.path.join(pack_path, context_name)
            ogg_files = [f for f in os.listdir(context_path) if f.lower().endswith(".ogg")]
            ogg_files.sort()

            context_arrays[context_name] = []

            for file in ogg_files:
                base_name = os.path.splitext(file)[0]
                sanitized_base = sanitize_classname(base_name)
                class_name = f"{pack_name}_{context_name}_{sanitized_base}"
                rel_path = f"sounds\\voicepacks\\{pack_name}\\{context_name}\\{file}"

                context_arrays[context_name].append(class_name)
                sound_count += 1
                total_sounds += 1

        # --- Comment block FIRST ---
        lines.append("    /*")
        lines.append(f"    {pack_name} voicepack arrays")
        for ctx, arr in context_arrays.items():
            lines.append(f"    {ctx} [{', '.join(arr)}]")
        lines.append("    */")

        # --- Class definitions ---
        for context_name, arr in context_arrays.items():
            context_path = os.path.join(pack_path, context_name)
            ogg_files = [f for f in os.listdir(context_path) if f.lower().endswith(".ogg")]
            ogg_files.sort()

            for i, class_name in enumerate(arr):
                original_file = ogg_files[i]
                rel_path = f"sounds\\voicepacks\\{pack_name}\\{context_name}\\{original_file}"
                lines.append(f"    class {class_name} {{")
                lines.append(f"        name = \"{class_name}\";")
                lines.append(f"        sound[] = {{\"{rel_path}\", 5, 1}};")
                lines.append("        titles[] = {};")
                lines.append("    };")

        # --- Register lines (snippet) ---
        block = []
        for ctx, arr in context_arrays.items():
            arr_str = ", ".join([f"\"{a}\"" for a in arr])
            block.append(f"[\"{pack_name}\", \"{ctx}\", [{arr_str}]] call _register;")

            ogg_files = sorted([f for f in os.listdir(os.path.join(pack_path, ctx)) if f.lower().endswith(".ogg")])
            path_arr = [f"sounds/voicepacks/{pack_name}/{ctx}/{f}" for f in ogg_files]
            path_str = ", ".join([f"\"{p}\"" for p in path_arr])
            block.append(f"[\"{pack_name}\", \"{ctx}\", [{path_str}]] call _registerPath;")

        register_lines.append("\n".join(block))
        print(f"  Added {sound_count} sounds for {pack_name}")

    # Close CfgSounds
    lines.append("};")
    print(f"Total sounds generated: {total_sounds}")

    # --- Write files ---
    try:
        with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
            f.write("\n".join(lines))
        print(f"\nSuccessfully generated {OUTPUT_FILE}")
    except Exception as e:
        print(f"Error writing file: {e}")

    init_file = OUTPUT_FILE.replace("voicepacks.hpp", "voicepacks_init_snippet.sqf")
    try:
        with open(init_file, "w", encoding="utf-8") as f:
            f.write("// === Auto-generated voicepack registration ===\n")
            f.write("// Paste this into fn_initVoicePacks.sqf\n\n")
            f.write("\n\n".join(register_lines))
            f.write("\n")
        print(f"Initializer snippet written to {init_file}")
    except Exception as e:
        print(f"Error writing snippet file: {e}")

if __name__ == "__main__":
    print("Arma 3 Voice Packs Generator")
    print("=" * 40)
    generate_cfgsounds()

