# rapidonvif 3rdparty libs

cmake_minimum_required(VERSION 3.0)

include(ExternalProject)

if (MSVC)
	set(live555_dll_products 
		"${CMAKE_BINARY_DIR}/live555-bin/bin/${CMAKE_STATIC_LIBRARY_PREFIX}live555_dll${CMAKE_STATIC_LIBRARY_SUFFIX}"
		"${CMAKE_BINARY_DIR}/live555-bin/bin/${CMAKE_SHARED_LIBRARY_PREFIX}live555_dll${CMAKE_SHARED_LIBRARY_SUFFIX}")
else(MSVC)
	set(live555_dll_products
		"${CMAKE_BINARY_DIR}/live555-bin/bin/${CMAKE_SHARED_LIBRARY_PREFIX}live555_dll${CMAKE_SHARED_LIBRARY_SUFFIX}")
endif(MSVC)

if (DEFINED CMAKE_TOOLCHAIN_FILE)
	set (set_toolchain "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
else(DEFINED CMAKE_TOOLCHAIN_FILE)
	set (set_toolchain "")
endif(DEFINED CMAKE_TOOLCHAIN_FILE)

ExternalProject_Add(live555 SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/live555" 
	CMAKE_ARGS "-B${CMAKE_BINARY_DIR}/live555-build" "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/live555-bin"
	"-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}" "-DUSE_STATIC_RT=${USE_STATIC_RT}" ${set_toolchain}
	BUILD_BYPRODUCTS 
	"${CMAKE_BINARY_DIR}/live555-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}BasicUsageEnvironment${CMAKE_STATIC_LIBRARY_SUFFIX}" 
	"${CMAKE_BINARY_DIR}/live555-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}groupsock${CMAKE_STATIC_LIBRARY_SUFFIX}" 
	"${CMAKE_BINARY_DIR}/live555-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}liveMedia${CMAKE_STATIC_LIBRARY_SUFFIX}" 
	"${CMAKE_BINARY_DIR}/live555-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}UsageEnvironment${CMAKE_STATIC_LIBRARY_SUFFIX}" 
	${live555_dll_products})

#ExternalProject_Add(civetweb SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/civetweb" 
#	CMAKE_ARGS "-B${CMAKE_BINARY_DIR}/civetweb-build" "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/civetweb-bin"
#	CMAKE_CACHE_ARGS "-DBUILD_TESTING:boolean=OFF")


if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(protobuf_lib "libprotobufd")
else(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(protobuf_lib "libprotobuf")
endif(CMAKE_BUILD_TYPE STREQUAL "Debug")

if(CMAKE_CROSSCOMPILING)
	if (NOT DEFINED protobuf_PROTOC_HOST_LOCATION OR NOT DEFINED js_embed_HOST)
		message(FATAL_ERROR "Cross compiling required setting protobuf_PROTOC_HOST_LOCATION and js_embed_HOST")
	endif(NOT DEFINED protobuf_PROTOC_HOST_LOCATION OR NOT DEFINED js_embed_HOST)
	
	ExternalProject_Add(protobuf SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/protobuf/cmake" 
	CMAKE_ARGS "-B${CMAKE_BINARY_DIR}/protobuf-build" "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/protobuf-bin"
	"-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}" "-DUSE_STATIC_RT=${USE_STATIC_RT}" ${set_toolchain}
	"-Dprotobuf_PROTOC_HOST_LOCATION=${protobuf_PROTOC_HOST_LOCATION}" "-Djs_embed_HOST=${js_embed_HOST}"
	BUILD_BYPRODUCTS 
	"${CMAKE_BINARY_DIR}/protobuf-bin/lib/${protobuf_lib}${CMAKE_STATIC_LIBRARY_SUFFIX}")
else(CMAKE_CROSSCOMPILING)
	ExternalProject_Add(protobuf SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/protobuf/cmake" 
	CMAKE_ARGS "-B${CMAKE_BINARY_DIR}/protobuf-build" "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/protobuf-bin"
	"-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}" "-DUSE_STATIC_RT=${USE_STATIC_RT}" ${set_toolchain}
	BUILD_BYPRODUCTS 
	"${CMAKE_BINARY_DIR}/protobuf-bin/lib/${protobuf_lib}${CMAKE_STATIC_LIBRARY_SUFFIX}")
endif(CMAKE_CROSSCOMPILING)


ExternalProject_Add(libressl SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libressl-2.5.4" 
	CMAKE_ARGS "-B${CMAKE_BINARY_DIR}/libressl-build" "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/libressl-bin"
	"-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}" "-DUSE_STATIC_RT=${USE_STATIC_RT}" ${set_toolchain}
	BUILD_BYPRODUCTS 
	"${CMAKE_BINARY_DIR}/libressl-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ssl${CMAKE_STATIC_LIBRARY_SUFFIX}" 
	"${CMAKE_BINARY_DIR}/libressl-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}tls${CMAKE_STATIC_LIBRARY_SUFFIX}"
	"${CMAKE_BINARY_DIR}/libressl-bin/lib/${CMAKE_STATIC_LIBRARY_PREFIX}crypto${CMAKE_STATIC_LIBRARY_SUFFIX}")