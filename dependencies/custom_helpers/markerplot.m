function markerplot(x_values, y_matrix, axis_scale)

  % size_y = sort(size(y_matrix));
  % size_x = size(x_values);
  % size_x = size_x(size_x ~= 1);
  % if size_y(1) == size_x
  %   number_of_plots = size_y(2);
  % else
  %   number_of_plots = size_y(1);
  % end
  % if number_of_plots < 8
  %   colors = linspecer(number_of_plots, 'qualitative');
  %   set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
  % end



  if ~exist('axis_scale', 'var')
    handles = plot(x_values, y_matrix);
  else
    if strcmp(axis_scale, 'semilogx')
      handles = semilogx(x_values, y_matrix);
    elseif strcmp(axis_scale, 'semilogy')
      handles = semilogy(x_values, y_matrix);
    elseif strcmp(axis_scale, 'loglog')
      handles = loglog(x_values, y_matrix);
    end
  end

  set_markers(handles);
end
