# Defines:
#  DirectX_D3D9_INCLUDE_FOUND
#  DirectX_D3D9_INCLUDE_DIR

include(CheckIncludeFileCXX)
include(FindPackageMessage)

if(WIN32)
  macro (find_winsdk_header var_name header)
    set (include_dir_var "DirectX_${var_name}_INCLUDE_DIR")
    set (include_found_var "DirectX_${var_name}_INCLUDE_FOUND")
    check_include_file_cxx (${header} ${include_found_var})
    set (${include_dir_var})
    mark_as_advanced (${include_found_var})
  endmacro ()

  find_winsdk_header(D3D9 d3d9.h)
endif()
