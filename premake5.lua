-- Project Definition for EnTT
project "EnTT"
    kind "StaticLib"  -- EnTT is a header-only static library
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    -- Version (This part doesn't directly translate, but you could manage version manually if needed)
    defines { "ENTT_VERSION=\"3.0\"" }

    -- Include directories (same as CMake's `target_include_directories`)
    includedirs {
        "src",       -- main source directory
        "tools",     -- tools
    }

    -- Source files (we include everything under the `src` directory)
    files { "src/**.hpp", "src/**.h", "src/**.cpp" }

    -- Compiler Options
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

    -- If using libcpp (handling sanitizer and clang-tidy in Premake is more manual)
    filter "options:ENTT_USE_LIBCPP"
        buildoptions { "-stdlib=libc++" }

    -- If enabling sanitizers in Debug mode
    filter "configurations:Debug"
        buildoptions { "-fsanitize=address", "-fno-omit-frame-pointer", "-fsanitize=undefined" }
        linkoptions { "-fsanitize=address", "-fno-omit-frame-pointer", "-fsanitize=undefined" }

    -- Static analysis with clang-tidy (Premake doesn't directly configure `clang-tidy` via `CMake`, this requires additional setup)
    filter "options:ENTT_USE_CLANG_TIDY"
        buildoptions { "-Xclang -load -Xclang clang-tidy" }

    -- Test and example configurations (similar to CMake options)
    filter "options:ENTT_BUILD_TESTBED"
        -- Add your testbed subdirectory if it's relevant for your project
        -- add_subdirectory('testbed') equivalent in Premake would be handled by using external project setup

    filter "options:ENTT_BUILD_TESTING"
        -- Add unit test configurations if you use something like Google Test (GTest) with CTest
        -- Premake will need additional setup for testing frameworks
    
    -- Documentation
    filter "options:ENTT_BUILD_DOCS"
        -- Similar setup for documentation can be added if you generate docs using tools like Doxygen
        -- add_subdirectory('docs') equivalent in Premake

-- Optional settings for tools (like natvis files)
filter "options:ENTT_INCLUDE_NATVIS"
    if _OPTIONS["ENTT_INCLUDE_NATVIS"] then
        files {
            "natvis/entt/config.natvis",
            "natvis/entt/container.natvis",
            "natvis/entt/core.natvis",
            "natvis/entt/entity.natvis",
            "natvis/entt/graph.natvis",
            "natvis/entt/locator.natvis",
            "natvis/entt/meta.natvis",
            "natvis/entt/poly.natvis",
            "natvis/entt/process.natvis",
            "natvis/entt/resource.natvis",
            "natvis/entt/signal.natvis"
        }
    end

-- Example for installing if required (Premake's installation is more manual compared to CMake)
-- This would require an additional script or manual steps for file copy, handling pkg-config, etc.

-- Test or other optional modules
filter "options:ENTT_INCLUDE_TOOLS"
    files { "tools/entt/davey/davey.hpp" }

-- Define build options
newoption {
    trigger = "ENTT_USE_LIBCPP",
    description = "Enable libc++ support"
}

newoption {
    trigger = "ENTT_USE_SANITIZER",
    description = "Enable address sanitizer"
}

newoption {
    trigger = "ENTT_USE_CLANG_TIDY",
    description = "Enable clang-tidy static analysis"
}

newoption {
    trigger = "ENTT_BUILD_TESTBED",
    description = "Enable building testbed"
}

newoption {
    trigger = "ENTT_BUILD_TESTING",
    description = "Enable building tests"
}

newoption {
    trigger = "ENTT_BUILD_DOCS",
    description = "Enable building documentation"
}

