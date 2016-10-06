function my_export_fig(filename)
  full_path = fullfile(Constants.PLOTS_DIR, filename);
  export_fig(full_path) 
end
