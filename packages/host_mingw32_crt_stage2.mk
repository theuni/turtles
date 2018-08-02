package=host_mingw32_crt_stage2
$(package)_version=5.0.1
$(package)_sha256_hash=9bb5cd7df78817377841a63555e73596dc0af4acbb71b09bd48de7cf24aeadd2
$(package)_download_path=https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release
$(package)_file_name=mingw-w64-v$($(package)_version).tar.bz2
$(package)_dependencies=host_gcc host_mingw32_system_headers host_binutils
$(package)_build_subdir=mingw-w64-crt

define $(package)_set_vars
  $(package)_config_opts=--prefix=$($(package)_prefix)/$(host)
  $(package)_config_opts+=--host=$(host)
endef

define $(package)_config_cmds
  export PATH="$($(package)_prefixbin):$(PATH)" && \
 ./configure $($(package)_config_opts) CFLAGS="-O2 -fstack-protector-strong -D_FORTIFY_SOURCE=2"
endef

define $(package)_build_cmds
  export PATH="$($(package)_prefixbin):$(PATH)" && \
  $(MAKE)
endef

define $(package)_stage_cmds
  mkdir -p $($(package)_staging_prefix_dir) && \
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
