add_rules("mode.debug", "mode.release", "mode.releasedbg")

set_languages("c++23")

option("commonlib")
    set_default("skyrim-commonlib-ng")
option_end()

option("build_example")
    set_default(true)
option_end()

if not has_config("commonlib") then
    return
end

commonlib_version = get_config("commonlib"):match("skyrim%-commonlib%-(.*)")

library_name = "SkyrimScripting.Plugin"

if get_config("build_example") then
    add_repositories("SkyrimScripting     https://github.com/SkyrimScripting/Packages.git")
    add_repositories("SkyrimScriptingBeta https://github.com/SkyrimScriptingBeta/Packages.git")
    add_repositories("MrowrLib            https://github.com/MrowrLib/Packages.git")
end

add_requires(get_config("commonlib"))
add_requires("skse_plugin_info")
add_requires("SkyrimScripting.Entrypoint",    { configs = { commonlib = get_config("commonlib") } })
add_requires("SkyrimScripting.Logging",       { configs = { commonlib = get_config("commonlib") } })
add_requires("SkyrimScripting.SKSE_Messages", { configs = { commonlib = get_config("commonlib") } })

target(library_name)
    set_kind("static")
    add_files("src/*.cpp")
    add_includedirs("include", { public = true }) -- Your library's own include path
    add_headerfiles("include/(**.h)")
    add_packages(get_config("commonlib"), { public = true })
    add_packages("skse_plugin_info", { public = true })
    add_packages("SkyrimScripting.Entrypoint", { public = true })
    add_packages("SkyrimScripting.Logging", { public = true })
    add_packages("SkyrimScripting.SKSE_Messages", { public = true })

if get_config("build_example") then
    mod_info = { name = "Test plugin for " .. library_name }

    mods_folders = os.getenv("SKYRIM_MODS_FOLDERS")

    if mods_folders then
        mod_info.mods_folders = mods_folders
    else
        print("SKYRIM_MODS_FOLDERS environment variable not set")
    end
    
    target("_SksePlugin-" .. commonlib_version:upper())
        set_basename(mod_info.name .. "-" .. commonlib_version:upper())
        add_files("*.cpp")
        add_rules("@skyrim-commonlib-" .. commonlib_version .. "/plugin", {
            mod_name = mod_info.name .. " (" .. commonlib_version .. ")",
            mods_folders = mod_info.mods_folders or "",
            mod_files = mod_info.mod_files,
            name = mod_info.name,
            version = mod_info.version,
            author = mod_info.author,
            email = mod_info.email
        })
        add_deps(library_name)
end
