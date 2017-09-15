pkg_name=azure-voting-app-redis
pkg_origin=kbhimanavarjula
pkg_version="0.1.0"
pkg_maintainer="Krishna Bhimanavarjula <kbhimanavarjula>"
pkg_license=('MIT')
pkg_source="https://github.com/kbhimanavarjula/azure-voting-app-redis"
#pkg_source=false
#pkg_deps=(core/python2 python/python2-pip/9.0.1/20170110100823 python2/flask/0.12.1/20170514070418  core/coreutils)
pkg_build_deps=(core/virtualenv ) 
pkg_deps=(core/coreutils core/python2 core/git)
# pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
# pkg_shasum="TODO"
# pkg_deps=(core/glibc)
# pkg_build_deps=(core/make core/gcc)
# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
pkg_svc_run="azure-voting-app-redis -o 0.0.0.0 --config  $pkg_svc_config_path/config.yml"
pkg_exports=(8080)
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )
#pkg_exposes=(8080)
# pkg_binds=(
#   [database]="port host"
# )
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
pkg_svc_user="root"
pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"

do_download()  
{
        build_line "do_download() =================================================="  
        cd ${HAB_CACHE_SRC_PATH}

        build_line "\$pkg_dirname=${pkg_dirname}"  
        build_line "\$pkg_filename=${pkg_filename}"

        if [ -d "${pkg_dirname}" ];  
        then  
            rm -rf ${pkg_dirname}  
        fi

        mkdir ${pkg_dirname}  
        cd ${pkg_dirname}  
        GIT_SSL_NO_VERIFY=true git clone --branch master https://github.com/kbhimanavarjula/azure-voting-app-redis.git  
        return 0  
}


do_clean()  
{
        build_line "do_clean() ===================================================="  
        return 0  
}

do_unpack()  
{
        # Nothing to unpack as we are pulling our code straight from github  
	# Because our habitat files liver under build/.
	PROJECT_ROOT="${PLAN_CONTEXT}/.."
    	mkdir -p $pkg_prefix
    	build_line "Copying project data to $pkg_prefix/"
    	#cp -r $PROJECT_ROOT/app $pkg_prefix/
    	#cp -r $PROJECT_ROOT/*.py $pkg_prefix/
    	local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}"
	cp -r  ${source_dir}/requirements.txt $pkg_prefix/
        return 0  
}

do_build()  
{
    #build_line "do_build() ===================================================="

    # Maven requires JAVA_HOME to be set, and can be set via:  
    #export JAVA_HOME=$(hab pkg path core/jdk8)

    #cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}  
#    mvn package  
    return 0
}

do_install()  
{
        build_line "do_install() =================================================="

        # Our source files were copied over to the HAB_CACHE_SRC_PATH in do_build(),  
        # so now they need to be copied into the root directory of our package through  
        # the pkg_prefix variable. This is so that we have the source files available  
        # in the package.

        #local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}"  
        #local webapps_dir="$(hab pkg path core/tomcat8)/tc/webapps"  
        #cp ${source_dir}/target/${pkg_filename}.war ${webapps_dir}/

        # Copy our seed data so that it can be loaded into Mongo using our init hook  
        #cp ${source_dir}/azure-vote/azure-vote/config_file.cfg  $(hab pkg path ${pkg_origin}/azure-voting-app-redis)/  
#	build_line "pkg prefix is $pkg_prefix"
#	cd $pkg_prefix
#	build_line "source dir is ${source_dir}"
	virtualenv venv
    	source venv/bin/activate
	local source_dir="${HAB_CACHE_SRC_PATH}/${pkg_dirname}/${pkg_filename}"
	build_line "source dir is ${source_dir}"	
    	pip install -r "${source_dir}/requirements.txt"

}

