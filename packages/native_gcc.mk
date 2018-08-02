package=native_gcc
$(package)_version=8.2.0
$(package)_download_path=https://ftpmirror.gnu.org/gcc/gcc-$($(package)_version)
$(package)_file_name=gcc-$($(package)_version).tar.xz
$(package)_sha256_hash=196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080
$(package)_build_subdir=build
$(package)_dependencies=native_binutils
$(package)_mingw32_dependencies=native_mingw-w64-headers
$(package)_patches=0009-stabilize-ira-color.patch 0011-tree-ssa-loop-im-small-fix.patch

$(package)_mpfr_version=4.0.1
$(package)_mpfr_download_path=https://ftpmirror.gnu.org/mpfr
$(package)_mpfr_file_name=mpfr-$($(package)_mpfr_version).tar.xz
$(package)_mpfr_sha256_hash=67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e

$(package)_gmp_version=6.1.2
$(package)_gmp_download_path=https://ftpmirror.gnu.org/gmp
$(package)_gmp_file_name=gmp-$($(package)_gmp_version).tar.xz
$(package)_gmp_sha256_hash=87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912

$(package)_mpc_version=1.1.0
$(package)_mpc_download_path=https://ftpmirror.gnu.org/mpc
$(package)_mpc_file_name=mpc-$($(package)_mpc_version).tar.gz
$(package)_mpc_sha256_hash=6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e

$(package)_extra_sources=$($(package)_mpfr_file_name) $($(package)_gmp_file_name) $($(package)_mpc_file_name)

define $(package)_fetch_cmds
$(call fetch_file,$(package),$($(package)_download_path),$($(package)_file_name),$($(package)_file_name),$($(package)_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpfr_download_path),$($(package)_mpfr_file_name),$($(package)_mpfr_file_name),$($(package)_mpfr_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_gmp_download_path),$($(package)_gmp_file_name),$($(package)_gmp_file_name),$($(package)_gmp_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpc_download_path),$($(package)_mpc_file_name),$($(package)_mpc_file_name),$($(package)_mpc_sha256_hash))
endef

define $(package)_extract_cmds
  mkdir -p $($(package)_extract_dir) && \
  echo "$($(package)_sha256_hash)  $($(package)_source)" > $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_mpfr_sha256_hash)  $($(package)_source_dir)/$($(package)_mpfr_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_gmp_sha256_hash)  $($(package)_source_dir)/$($(package)_gmp_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_mpc_sha256_hash)  $($(package)_source_dir)/$($(package)_mpc_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  $(build_SHA256SUM) -c $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  tar --strip-components=1 -xf $($(package)_source) && \
  mkdir -p mpfr && tar --strip-components=1 -C mpfr -xf $($(package)_source_dir)/$($(package)_mpfr_file_name) && \
  mkdir -p gmp && tar --strip-components=1 -C gmp -xf $($(package)_source_dir)/$($(package)_gmp_file_name) && \
  mkdir -p mpc && tar --strip-components=1 -C mpc -xf $($(package)_source_dir)/$($(package)_mpc_file_name)
endef

define $(package)_set_vars
  $(package)_config_opts=
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--with-newlib
  $(package)_config_opts+=--without-headers
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--with-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--program-prefix=$(build)-
  $(package)_config_opts+=--disable-nls
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--disable-decimal-float
  $(package)_config_opts+=--disable-threads
  $(package)_config_opts+=--disable-libatomic
  $(package)_config_opts+=--disable-libgomp
  $(package)_config_opts+=--disable-libmpx
  $(package)_config_opts+=--disable-libquadmath
  $(package)_config_opts+=--disable-libvtv
  $(package)_config_opts+=--disable-libssp
  $(package)_config_opts+=--enable-languages=c
  $(package)_config_opts+=--enable-checking=release
  $(package)_config_opts+=--enable-default-pie
  $(package)_config_opts+=--disable-lto
  $(package)_config_opts+=--disable-bootstrap
  $(package)_config_opts+=--disable-werror
  $(package)_config_opts+=--with-build-time-tools=$($(package)_prefix)/bin
  $(package)_config_opts+=CC=$(old_build_toolchain_CC)
  $(package)_config_opts+=CXX=$(old_build_toolchain_CXX)
  $(package)_config_opts+=AR=$(old_build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(old_build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(old_build_toolchain_STRIP)
  $(package)_config_opts+=NM=$(old_build_toolchain_NM)
  $(package)_config_opts+=CFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CXXFLAGS=$($(package)_cflags)
endef

define $(package)_config_cmds
  ../configure $$($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip
endef
