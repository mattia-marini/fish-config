#!/usr/bin/env fish

function deploy-repo
  set output_dir "./"
  set output_name $(date "+%d-%m-%y")
  set full_output "$output_dir$output_name"
  
  set java_mvn_excludes
  set java_mvn_excluded_dir
  
  # java mvn project
  for file in (find . -type f -name "pom.xml")
      set dir (dirname $file)
      set java_mvn_excluded_dir $java_mvn_excluded_dir $dir
  
      set dir (string replace -r '^\\./' '' $dir)
      set java_mvn_excludes $java_mvn_excludes --exclude $dir/
  end
  
  
  set python_uv_excludes
  set python_uv_excluded_dir
  
  # python uv project
  for file in (find . -type f -name "pyproject.toml")
      set dir (dirname $file)
      set python_uv_excluded_dir $python_uv_excluded_dir $dir
  
      set dir (string replace -r '^\\./' '' $dir)
      set python_uv_excludes $python_uv_excludes --exclude $dir/.venv
      set python_uv_excludes $python_uv_excludes --exclude $dir/__pycache__
      set python_uv_excludes $python_uv_excludes --exclude $dir/.python-version
      set python_uv_excludes $python_uv_excludes --exclude $dir/README.md
      set python_uv_excludes $python_uv_excludes --exclude $dir/pyproject.toml
      set python_uv_excludes $python_uv_excludes --exclude $dir/uv.lock
  end                                                           
  
  rsync -a \
    --exclude 'a.out' \
    --exclude '.DS_Store' \
    --exclude '.gitignore' \
    $java_mvn_excludes \
    $python_uv_excludes \
    --include 'files/' \
    --include 'files/***' \
    --include 'main.pdf' \
    --exclude '*' \
    ./ ./$full_output
  
  for excluded_dir in $java_mvn_excluded_dir
      set out ./$full_output/$(path normalize $excluded_dir)
      mkdir -p $out/src
      cp -r $excluded_dir/src/main/java/com/mycompany/* $out/src
  
      rsync -a \
        --exclude 'src' \
        --exclude '.classpath' \
        --exclude '.gitignore' \
        --exclude '.mvn' \
        --exclude '.project' \
        --exclude '.settings' \
        --exclude 'pom.xml' \
        --exclude 'target' \
        $excluded_dir/ $out
  end

  echo (set_color green)"Repo deployed to $full_output" (set_color normal)
end
