find_package(Qt6 REQUIRED COMPONENTS
    Core Gui Svg Widgets PrintSupport Network
    WebEngineWidgets WebChannel WebSockets
    Core5Compat LinguistTools
)
if(UNIX AND NOT APPLE)
    find_package(Qt6 REQUIRED COMPONENTS DBus)
endif()

if(WIN32)
    # On Windows (vcpkg), use find_path/find_library for uchardet
    find_path(UCHARDET_INCLUDE_DIR uchardet.h PATH_SUFFIXES uchardet)
    find_library(UCHARDET_LIBRARY uchardet)
    if(NOT UCHARDET_INCLUDE_DIR OR NOT UCHARDET_LIBRARY)
        message(FATAL_ERROR "uchardet not found. Install via vcpkg: vcpkg install uchardet")
    endif()
    add_library(uchardet::uchardet UNKNOWN IMPORTED)
    set_target_properties(uchardet::uchardet PROPERTIES
        IMPORTED_LOCATION "${UCHARDET_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${UCHARDET_INCLUDE_DIR}"
    )
    set(UCHARDET_TARGET uchardet::uchardet)
else()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(UCHARDET REQUIRED IMPORTED_TARGET uchardet)
    set(UCHARDET_TARGET PkgConfig::UCHARDET)
endif()

# ---------- sources ----------
set(SOURCES
    main.cpp
    mainwindow.cpp
    topeditorcontainer.cpp
    editortabwidget.cpp
    docengine.cpp
    frmabout.cpp
    notepadqq.cpp
    frmpreferences.cpp
    iconprovider.cpp
    EditorNS/editor.cpp
    EditorNS/bannerfilechanged.cpp
    EditorNS/bannerbasicmessage.cpp
    EditorNS/bannerfileremoved.cpp
    EditorNS/customqwebview.cpp
    EditorNS/languageservice.cpp
    clickablelabel.cpp
    frmencodingchooser.cpp
    EditorNS/bannerindentationdetected.cpp
    frmindentationmode.cpp
    singleapplication.cpp
    localcommunication.cpp
    Search/frmsearchreplace.cpp
    Search/searchstring.cpp
    Search/advancedsearchdock.cpp
    Extensions/extension.cpp
    frmlinenumberchooser.cpp
    Extensions/extensionsserver.cpp
    Extensions/Stubs/stub.cpp
    Extensions/runtimesupport.cpp
    Extensions/Stubs/windowstub.cpp
    Extensions/Stubs/notepadqqstub.cpp
    Extensions/Stubs/editorstub.cpp
    Extensions/extensionsloader.cpp
    globals.cpp
    Extensions/Stubs/menuitemstub.cpp
    Extensions/installextension.cpp
    keygrabber.cpp
    Sessions/sessions.cpp
    Sessions/persistentcache.cpp
    nqqsettings.cpp
    nqqrun.cpp
    Search/filesearcher.cpp
    Search/filereplacer.cpp
    Search/searchobjects.cpp
    Search/searchinstance.cpp
    stats.cpp
    Sessions/backupservice.cpp
    svgiconengine.cpp
)

set(HEADERS
    include/mainwindow.h
    include/topeditorcontainer.h
    include/editortabwidget.h
    include/docengine.h
    include/frmabout.h
    include/notepadqq.h
    include/frmpreferences.h
    include/iconprovider.h
    include/EditorNS/editor.h
    include/EditorNS/bannerfilechanged.h
    include/EditorNS/bannerbasicmessage.h
    include/EditorNS/bannerfileremoved.h
    include/EditorNS/customqwebview.h
    include/clickablelabel.h
    include/frmencodingchooser.h
    include/EditorNS/bannerindentationdetected.h
    include/EditorNS/languageservice.h
    include/frmindentationmode.h
    include/singleapplication.h
    include/localcommunication.h
    include/Search/frmsearchreplace.h
    include/Search/advancedsearchdock.h
    include/Search/searchhelpers.h
    include/Search/searchstring.h
    include/Extensions/extension.h
    include/frmlinenumberchooser.h
    include/Extensions/extensionsserver.h
    include/Extensions/Stubs/stub.h
    include/Extensions/runtimesupport.h
    include/Extensions/Stubs/windowstub.h
    include/Extensions/Stubs/notepadqqstub.h
    include/Extensions/Stubs/editorstub.h
    include/Extensions/extensionsloader.h
    include/globals.h
    include/Extensions/Stubs/menuitemstub.h
    include/Extensions/installextension.h
    include/keygrabber.h
    include/Sessions/sessions.h
    include/Sessions/persistentcache.h
    include/nqqsettings.h
    include/nqqrun.h
    include/Search/filesearcher.h
    include/Search/searchobjects.h
    include/Search/filereplacer.h
    include/Search/searchinstance.h
    include/stats.h
    include/Sessions/backupservice.h
    include/svgiconengine.h
)

set(FORMS
    mainwindow.ui
    frmabout.ui
    frmpreferences.ui
    frmencodingchooser.ui
    frmindentationmode.ui
    Search/dlgsearching.ui
    Search/frmsearchreplace.ui
    frmlinenumberchooser.ui
    Extensions/installextension.ui
)

# ---------- translations ----------
# The .qm files are embedded via resources.qrc which references them at
# ../translations/*.qm (relative to src/ui/).  We run lrelease at build time
# to generate them in-tree, matching the old qmake behaviour.
set(TS_FILES
    ../translations/notepadqq_de.ts
    ../translations/notepadqq_es.ts
    ../translations/notepadqq_fr.ts
    ../translations/notepadqq_hu.ts
    ../translations/notepadqq_it.ts
    ../translations/notepadqq_ja.ts
    ../translations/notepadqq_pl.ts
    ../translations/notepadqq_pt.ts
    ../translations/notepadqq_ru.ts
    ../translations/notepadqq_sl.ts
    ../translations/notepadqq_sv.ts
    ../translations/notepadqq_uk.ts
    ../translations/notepadqq_zh.ts
)

# Build absolute paths and derive .qm paths
set(QM_FILES "")
foreach(TS_FILE ${TS_FILES})
    get_filename_component(TS_ABS "${TS_FILE}" ABSOLUTE)
    string(REGEX REPLACE "\\.ts$" ".qm" QM_ABS "${TS_ABS}")
    list(APPEND QM_FILES "${QM_ABS}")
    add_custom_command(
        OUTPUT "${QM_ABS}"
        COMMAND Qt6::lrelease "${TS_ABS}" -qm "${QM_ABS}"
        DEPENDS "${TS_ABS}"
        COMMENT "Compiling translation ${TS_FILE}"
        VERBATIM
    )
endforeach()
add_custom_target(translations ALL DEPENDS ${QM_FILES})

# ---------- target name ----------
if(APPLE)
    set(EXE_NAME notepadqq)
elseif(WIN32)
    set(EXE_NAME notepadqq)
else()
    set(EXE_NAME notepadqq-bin)
endif()

if(APPLE)
    set(MACOSX_BUNDLE_ICON_FILE notepadqq.icns)
    set(APP_ICON_MACOS "${CMAKE_SOURCE_DIR}/images/notepadqq.icns")
    set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
    qt_add_executable(${EXE_NAME} MACOSX_BUNDLE
        ${SOURCES} ${HEADERS} ${FORMS}
        resources.qrc
        ${APP_ICON_MACOS}
    )
    set_target_properties(${EXE_NAME} PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
    )
else()
    qt_add_executable(${EXE_NAME}
        ${SOURCES} ${HEADERS} ${FORMS}
        resources.qrc
    )
endif()

# Ensure translations are built before the main target (qrc embeds the .qm files)
add_dependencies(${EXE_NAME} translations)

target_include_directories(${EXE_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/qtpromise/include
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/qtpromise/src
)

target_compile_definitions(${EXE_NAME} PRIVATE
    QT_NO_URL_CAST_FROM_STRING
)

if(MSVC)
    target_compile_options(${EXE_NAME} PRIVATE /W3)
else()
    target_compile_options(${EXE_NAME} PRIVATE -Wold-style-cast)
endif()

target_link_libraries(${EXE_NAME} PRIVATE
    Qt6::Core Qt6::Gui Qt6::Svg Qt6::Widgets
    Qt6::PrintSupport Qt6::Network
    Qt6::WebEngineWidgets Qt6::WebChannel Qt6::WebSockets
    Qt6::Core5Compat
    ${UCHARDET_TARGET}
)
if(UNIX AND NOT APPLE)
    target_link_libraries(${EXE_NAME} PRIVATE Qt6::DBus)
endif()

# Clear RPATH so LD_LIBRARY_PATH works on Linux
if(UNIX AND NOT APPLE)
    set_target_properties(${EXE_NAME} PROPERTIES INSTALL_RPATH "")
endif()

# ---------- output directory ----------
set(OUT_DIR "${CMAKE_SOURCE_DIR}/out")
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    if(APPLE)
        set(BIN_OUT "${OUT_DIR}/debug")
    elseif(WIN32)
        set(BIN_OUT "${OUT_DIR}/debug")
    else()
        set(BIN_OUT "${OUT_DIR}/debug/lib")
    endif()
else()
    if(APPLE)
        set(BIN_OUT "${OUT_DIR}/release")
    elseif(WIN32)
        set(BIN_OUT "${OUT_DIR}/release")
    else()
        set(BIN_OUT "${OUT_DIR}/release/lib")
    endif()
endif()
set_target_properties(${EXE_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BIN_OUT}")

# ---------- copy editor & extension_tools at build time ----------
if(APPLE)
    set(APPDATA_DIR "${BIN_OUT}/${EXE_NAME}.app/Contents/Resources")
elseif(WIN32)
    set(APPDATA_DIR "${BIN_OUT}/appdata")
else()
    set(APPDATA_DIR "${BIN_OUT}/../appdata")
endif()

# Use a CMake script for cross-platform copying (works on Unix and Windows)
set(EDITOR_SRC_DIR "${CMAKE_SOURCE_DIR}/src/editor")
set(EDITOR_COPY_SCRIPT "${CMAKE_BINARY_DIR}/copy_editor.cmake")
file(WRITE "${EDITOR_COPY_SCRIPT}" "
file(REMOVE_RECURSE \"${APPDATA_DIR}/editor\")
file(MAKE_DIRECTORY \"${APPDATA_DIR}/editor\")
file(COPY
    \"${EDITOR_SRC_DIR}/classes\"
    \"${EDITOR_SRC_DIR}/styles\"
    \"${EDITOR_SRC_DIR}/features\"
    \"${EDITOR_SRC_DIR}/app.js\"
    \"${EDITOR_SRC_DIR}/index.html\"
    \"${EDITOR_SRC_DIR}/init.js\"
    \"${EDITOR_SRC_DIR}/Languages.json\"
    DESTINATION \"${APPDATA_DIR}/editor\"
)
file(MAKE_DIRECTORY \"${APPDATA_DIR}/editor/libs\")
file(COPY
    \"${EDITOR_SRC_DIR}/libs/jquery\"
    \"${EDITOR_SRC_DIR}/libs/MathJax\"
    \"${EDITOR_SRC_DIR}/libs/require.js\"
    \"${EDITOR_SRC_DIR}/libs/throttle-debounce\"
    \"${EDITOR_SRC_DIR}/libs/codemirror\"
    DESTINATION \"${APPDATA_DIR}/editor/libs\"
)
")

set(EXT_TOOLS_SRC_DIR "${CMAKE_SOURCE_DIR}/src/extension_tools")
set(EXT_TOOLS_COPY_SCRIPT "${CMAKE_BINARY_DIR}/copy_extension_tools.cmake")
file(WRITE "${EXT_TOOLS_COPY_SCRIPT}" "
file(REMOVE_RECURSE \"${APPDATA_DIR}/extension_tools\")
file(MAKE_DIRECTORY \"${APPDATA_DIR}/extension_tools\")
file(COPY
    \"${EXT_TOOLS_SRC_DIR}/node_modules\"
    \"${EXT_TOOLS_SRC_DIR}/install.js\"
    \"${EXT_TOOLS_SRC_DIR}/pack.js\"
    \"${EXT_TOOLS_SRC_DIR}/package.json\"
    \"${EXT_TOOLS_SRC_DIR}/readmanifest.js\"
    DESTINATION \"${APPDATA_DIR}/extension_tools\"
)
")

add_custom_command(TARGET ${EXE_NAME} POST_BUILD
    COMMENT "Copying editor files..."
    COMMAND ${CMAKE_COMMAND} -P "${EDITOR_COPY_SCRIPT}"
)

add_custom_command(TARGET ${EXE_NAME} POST_BUILD
    COMMENT "Copying extension_tools files..."
    COMMAND ${CMAKE_COMMAND} -P "${EXT_TOOLS_COPY_SCRIPT}"
)

# ---------- install rules (Linux) ----------
if(NOT APPLE)
    include(GNUInstallDirs)

    # Binary – use "lib" explicitly (not CMAKE_INSTALL_LIBDIR which may
    # resolve to lib/x86_64-linux-gnu) to match the launcher script expectation
    install(TARGETS ${EXE_NAME} DESTINATION "lib/notepadqq")

    # Launcher script
    install(PROGRAMS "${CMAKE_SOURCE_DIR}/support_files/launch/notepadqq"
        DESTINATION "${CMAKE_INSTALL_BINDIR}")

    # Desktop entry & appdata
    install(FILES "${CMAKE_SOURCE_DIR}/support_files/shortcuts/notepadqq.desktop"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
    install(FILES "${CMAKE_SOURCE_DIR}/support_files/notepadqq.appdata.xml"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/metainfo")

    # Icons
    foreach(SIZE 16 22 24 32 48 64 96 128 256 512)
        install(FILES
            "${CMAKE_SOURCE_DIR}/support_files/icons/hicolor/${SIZE}x${SIZE}/apps/notepadqq.png"
            DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/${SIZE}x${SIZE}/apps")
    endforeach()
    install(FILES
        "${CMAKE_SOURCE_DIR}/support_files/icons/hicolor/scalable/apps/notepadqq.svg"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps")

    # Shared data (editor, extension_tools)
    install(DIRECTORY "${APPDATA_DIR}/editor"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/notepadqq")
    install(DIRECTORY "${APPDATA_DIR}/extension_tools"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/notepadqq")

    # Translations
    install(FILES ${QM_FILES}
        DESTINATION "${CMAKE_INSTALL_DATADIR}/notepadqq/translations")
endif()
