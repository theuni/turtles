package=native_gcc_stage3
$(package)_version=$(native_gcc_version)
$(package)_download_path=$(native_gcc_download_path)
$(package)_file_name=$(native_gcc_file_name)
$(package)_sha256_hash=$(native_gcc_sha256_hash)
$(package)_build_subdir=build
$(package)_dependencies=native_binutils native_gcc_stage2 native_busybox
$(package)_linux_dependencies=native_musl native_linux_system_headers
$(package)_mingw32_dependencies=native_mingw-w64-headers native_mingw-w64-crt
$(package)_patches=0001-default-static-pie.patch 0002-autoconf.patch 0003-fixup-static-pie.patch
$(package)_patches+=0001-Introduce-gcc_qsort.patch 0002-gcc_qsort-avoid-oversized-memcpy-temporaries.patch 0003-gcc_qsort-avoid-overlapping-memcpy-PR-86311.patch 0004-qsort_chk-call-from-gcc_qsort-instead-of-wrapping-it.patch

$(package)_mpfr_version=$(native_gcc_mpfr_version)
$(package)_mpfr_download_path=$(native_gcc_mpfr_download_path)
$(package)_mpfr_file_name=$(native_gcc_mpfr_file_name)
$(package)_mpfr_sha256_hash=$(native_gcc_mpfr_sha256_hash)

$(package)_gmp_version=$(native_gcc_gmp_version)
$(package)_gmp_download_path=$(native_gcc_gmp_download_path)
$(package)_gmp_file_name=$(native_gcc_gmp_file_name)
$(package)_gmp_sha256_hash=$(native_gcc_gmp_sha256_hash)

$(package)_mpc_version=$(native_gcc_mpc_version)
$(package)_mpc_download_path=$(native_gcc_mpc_download_path)
$(package)_mpc_file_name=$(native_gcc_mpc_file_name)
$(package)_mpc_sha256_hash=$(native_gcc_mpc_sha256_hash)

$(package)_extra_sources=$($(package)_mpfr_file_name) $($(package)_gmp_file_name) $($(package)_mpc_file_name)

define $(package)_fetch_cmds
$(call fetch_file,$(package),$($(package)_download_path),$($(package)_file_name),$($(package)_file_name),$($(package)_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpfr_download_path),$($(package)_mpfr_file_name),$($(package)_mpfr_file_name),$($(package)_mpfr_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_gmp_download_path),$($(package)_gmp_file_name),$($(package)_gmp_file_name),$($(package)_gmp_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpc_download_path),$($(package)_mpc_file_name),$($(package)_mpc_file_name),$($(package)_mpc_sha256_hash))
endef

define $(package)_extract_cmds
  echo $($(package)_dependencies) && \
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

define $(package)_preprocess_cmds
  sed -i 's/-nostdinc++/-nostdinc++ \$$$$(XGCC_FLAGS_FOR_TARGET)/' Makefile.in && \
  patch -p1 < $($(package)_patch_dir)/0001-default-static-pie.patch && \
  patch -p1 < $($(package)_patch_dir)/0002-autoconf.patch && \
  patch -p1 < $($(package)_patch_dir)/0003-fixup-static-pie.patch && \
  patch -p1 < $($(package)_patch_dir)/0001-Introduce-gcc_qsort.patch && \
  patch -p1 < $($(package)_patch_dir)/0002-gcc_qsort-avoid-oversized-memcpy-temporaries.patch && \
  patch -p1 < $($(package)_patch_dir)/0003-gcc_qsort-avoid-overlapping-memcpy-PR-86311.patch && \
  patch -p1 < $($(package)_patch_dir)/0004-qsort_chk-call-from-gcc_qsort-instead-of-wrapping-it.patch
endef

define $(package)_set_vars
  $(package)_config_opts=--enable-languages=c,c++
  $(package)_config_opts+=--disable-nls
  $(package)_config_opts+=--enable-clocale
  $(package)_config_opts+=--enable-threads=posix
  $(package)_config_opts+=--enable-libstdcxx-threads
  $(package)_config_opts+=--enable-initfini-array
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--disable-multiarch
  $(package)_config_opts+=--enable-linker-build-id
  $(package)_config_opts+=--without-included-gettext
  $(package)_config_opts+=--enable-libstdcxx-time=yes
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--disable-libgomp
  $(package)_config_opts+=--enable-bootstrap
  $(package)_config_opts+=--disable-libcilkrts
  $(package)_config_opts+=--with-pic
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--disable-libsanitizer
  $(package)_config_opts+=--with-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--with-build-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--with-native-system-header-dir=/include
  $(package)_config_opts+=--disable-libgomp
  $(package)_config_opts+=--disable-libmpx
  $(package)_config_opts+=--disable-libquadmath
  $(package)_config_opts+=--disable-libvtv
  $(package)_config_opts+=--disable-libitm
  $(package)_config_opts+=--disable-lto
  $(package)_config_opts+=--enable-checking=release
  $(package)_config_opts+=--disable-werror
  $(package)_config_opts+=--with-build-time-tools=$($(package)_prefix)/bin
  $(package)_config_opts+=--enable-version-specific-runtime-libs
  $(package)_config_opts+=--enable-default-ssp
  $(package)_config_opts+=--enable-default-pie
  $(package)_config_opts+=--enable-default-static-pie
  $(package)_config_opts+=CC=$(build_toolchain_CC)
  $(package)_config_opts+=CXX=$(build_toolchain_CXX)
  $(package)_config_opts+=AR=$(build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(build_toolchain_STRIP)
  $(package)_config_opts+=NM=$(build_toolchain_NM)
  $(package)_config_opts+=CFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CXXFLAGS=$($(package)_cxxflags)
endef

define $(package)_config_cmds
  ../configure $($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE) bootstrap
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip
endef

define $(package)_postprocess_cmds
  rm ./lib/gcc/$(build)/*/lib*.la && \
  rm -r ./share/man
endef
