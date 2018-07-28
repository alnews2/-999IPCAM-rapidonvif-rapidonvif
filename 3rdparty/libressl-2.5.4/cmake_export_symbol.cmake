macro(export_symbol TARGET FILENAME)

	set(FLAG "")

	if(WIN32)
		string(REPLACE ".sym" ".def" DEF_FILENAME ${FILENAME})
		file(WRITE ${DEF_FILENAME} "EXPORTS\n")
		file(READ ${FILENAME} SYMBOLS)
		file(APPEND ${DEF_FILENAME} "${SYMBOLS}")
		target_sources(${TARGET} PRIVATE ${DEF_FILENAME})

	elseif(APPLE)
		set(FLAG "-exported_symbols_list ${FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_SYSTEM_NAME MATCHES "HP-UX")
		file(READ ${FILENAME} SYMBOLS)
		string(REGEX REPLACE "\n$" "" SYMBOLS ${SYMBOLS})
		string(REPLACE "\n" "\n+e " SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".opt" OPT_FILENAME ${FILENAME})
		file(WRITE ${OPT_FILENAME} "+e ${SYMBOLS}")
		set(FLAG "-Wl,-c,${OPT_FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_SYSTEM_NAME MATCHES "SunOS")
		file(READ ${FILENAME} SYMBOLS)
		string(REPLACE "\n" ";\n" SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".ver" VER_FILENAME ${FILENAME})
		file(WRITE ${VER_FILENAME}
			"{\nglobal:\n${SYMBOLS}\nlocal:\n*;\n};\n")
		set(FLAG "-Wl,-M${VER_FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES "Clang")
		file(READ ${FILENAME} SYMBOLS)
		string(REPLACE "\n" ";\n" SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".ver" VER_FILENAME ${FILENAME})
		file(WRITE ${VER_FILENAME}
			"{\nglobal:\n${SYMBOLS}\nlocal:\n*;\n};\n")
		set(FLAG "-Wl,--version-script,\"${VER_FILENAME}\"")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})
	endif()

endmacro()
