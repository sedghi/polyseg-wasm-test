cmake_minimum_required(VERSION 3.24.2)
project(ICRPolySeg)

# -----------------------------------------------------------------------------
# EMSCRIPTEN only
# -----------------------------------------------------------------------------

if (NOT EMSCRIPTEN)
  message("This needs to run inside an Emscripten build environment")
  return ()
endif ()

# -----------------------------------------------------------------------------
# Handle VTK dependency
# -----------------------------------------------------------------------------


find_package(VTK REQUIRED)

if (NOT VTK_FOUND)
  message("${VTK_NOT_FOUND_MESSAGE}")
  return ()
endif ()

# -----------------------------------------------------------------------------
# WebAssembly build options
# - https://emscripten.org/docs/tools_reference/emcc.html#emcc-g3
#	- https://github.com/emscripten-core/emscripten/blob/main/src/settings.js
# -----------------------------------------------------------------------------


set(emscripten_link_options)
list(APPEND emscripten_link_options
  "-lembind"
  "-g0"
  "SHELL:--pre-js ${CMAKE_CURRENT_SOURCE_DIR}/locateFile.js"
  "SHELL:-s EXPORT_NAME=ICRPolySegApp"
  "SHELL:-s ALLOW_MEMORY_GROWTH=1"
  "SHELL:-s DEMANGLE_SUPPORT=1"
  "SHELL:-s MODULARIZE=1"
  "SHELL:-s USE_PTHREADS=0"
  "SHELL:-s WASM=1"
  "SHELL:-s EMULATE_FUNCTION_POINTER_CASTS=0"
  "SHELL:-s ERROR_ON_UNDEFINED_SYMBOLS=0"
  "SHELL:-s FILESYSTEM=0" # ToDo: can be set to OFF to reduce wasm file size
  "SHELL:-s EXPORT_ES6=1"
  "SHELL:-s USE_ES6_IMPORT_META=0"
  "SHELL:-s ENVIRONMENT=web"
  "SHELL:-s ASSERTIONS=0"
  "SHELL:-s DISABLE_EXCEPTION_CATCHING=1"
  # "SHELL:-s SINGLE_FILE=1"
)

# -----------------------------------------------------------------------------
# Build options
# -----------------------------------------------------------------------------

set(OPTIMIZE "BEST" CACHE STRING "Emscripten optimization")
set_property(CACHE OPTIMIZE PROPERTY
  STRINGS
    NO_OPTIMIZATION       # -O0
    LITTLE                # -O1
    MORE                  # -O2
    BEST                  # -O3
    SMALL                 # -Os
    SMALLEST              # -Oz
    SMALLEST_WITH_CLOSURE # -Oz --closure 1
)

if(OPTIMIZE STREQUAL "NO_OPTIMIZATION")
  list(APPEND emscripten_link_options
    "-O0"
  )
elseif(OPTIMIZE STREQUAL "LITTLE")
  list(APPEND emscripten_link_options
    "-O1"
  )
elseif(OPTIMIZE STREQUAL "MORE")
  list(APPEND emscripten_link_options
    "-O2"
  )
elseif(OPTIMIZE STREQUAL "BEST")
  list(APPEND emscripten_link_options
    "-O3"
  )
elseif(OPTIMIZE STREQUAL "SMALL")
  list(APPEND emscripten_link_options
    "-Os"
  )
elseif(OPTIMIZE STREQUAL "SMALLEST")
  list(APPEND emscripten_link_options
    "-Oz"
  )
elseif(OPTIMIZE STREQUAL "SMALLEST_WITH_CLOSURE")
  list(APPEND emscripten_link_options
    "-Oz"
    "SHELL:--closure 1"
  )
endif()

# -----------------------------------------------------------------------------
# Converters library adapted from PolySeg
# -----------------------------------------------------------------------------
add_subdirectory(converters)

get_target_property(CONVERTERS_INCLUDE_DIRECTORIES Converters INTERFACE_INCLUDE_DIRECTORIES)

set(CONVERTERS_ARCHIVE_FILEPATH "${CMAKE_CURRENT_BINARY_DIR}/converters/libConverters.a")

# -----------------------------------------------------------------------------
# Headers and sources
# -----------------------------------------------------------------------------
set(ICRPolySeg_SRCS
	ICRPolySeg.cxx
)

# -----------------------------------------------------------------------------
# Compile example code
# -----------------------------------------------------------------------------

# set(ICRPolySeg_LIBS ${VTK_LIBRARIES} ${CONVERTERS_ARCHIVE_FILEPATH})

set(ProjectWeekLibs VTK::CommonDataModel VTK::CommonCore VTK::CommonExecutionModel VTK::FiltersCore VTK::FiltersExtraction VTK::ImagingStencil VTK::ImagingStatistics VTK::ImagingMorphological)
set(ICRPolySeg_LIBS ${ProjectWeekLibs} ${CONVERTERS_ARCHIVE_FILEPATH})

add_executable(ICRPolySeg ${ICRPolySeg_SRCS})

target_include_directories(
  ICRPolySeg PRIVATE ${CONVERTERS_INCLUDE_DIRECTORIES}
)

# target_link_directories(
#   ICRPolySeg PRIVATE "/work/icrpolyseg/build/converters"
# )

target_link_libraries(ICRPolySeg PRIVATE ${ICRPolySeg_LIBS})

# target_compile_options(ICRPolySeg PUBLIC ${emscripten_compile_options})

target_link_options(ICRPolySeg PUBLIC ${emscripten_link_options})

# -----------------------------------------------------------------------------
# VTK modules initialization
# VTK autoinit subsystem: https://vtk.org/doc/nightly/html/group__module.html#gaa19497c3d949b3a93eaa13ed6df5d416
# -----------------------------------------------------------------------------

vtk_module_autoinit(
  TARGETS  ICRPolySeg
  MODULES  ${ProjectWeekLibs}
)

# -----------------------------------------------------------------------------
# Copy WASM & JS to Dist and Examples folders
# -----------------------------------------------------------------------------

add_custom_command(
  TARGET ICRPolySeg
  POST_BUILD
  COMMAND
    ${CMAKE_COMMAND} -E copy
      "${CMAKE_CURRENT_BINARY_DIR}/ICRPolySeg.wasm"
      "${CMAKE_CURRENT_BINARY_DIR}/../dist"
  COMMAND
    ${CMAKE_COMMAND} -E copy
      "${CMAKE_CURRENT_BINARY_DIR}/ICRPolySeg.wasm"
      "${CMAKE_CURRENT_BINARY_DIR}/../examples/public"
)

add_custom_command(
  TARGET ICRPolySeg
  POST_BUILD
  COMMAND
    ${CMAKE_COMMAND} -E copy
      "${CMAKE_CURRENT_BINARY_DIR}/ICRPolySeg.js"
      "${CMAKE_CURRENT_BINARY_DIR}/../dist"
  COMMAND
    ${CMAKE_COMMAND} -E copy
      "${CMAKE_CURRENT_BINARY_DIR}/ICRPolySeg.js"
      "${CMAKE_CURRENT_BINARY_DIR}/../examples/src/lib/icrpolyseg"
)
