function make_legend_tolerances(tolerances)
  legend_labels = arrayfun(@legend_label, tolerances, 'UniformOutput', false);
  legend(legend_labels, 'Location', 'best');
end

function label = legend_label(tolerance)
  label = ['tolerance = $' to_tex(tolerance) '$'];
end

function strings = scientific_notation_to_tex(numbers)
  strings = arrayfun(@to_tex, numbers, 'UniformOutput', false);
end

function string = to_tex(number)
  [exponent, mantissa] = mantexpnt(number);
  if mantissa == 1
    mantissa_string = '10';
  else
    mantissa_string = [num2str(mantissa) '\cdot' '10'];
  end

  string = [mantissa_string '^{' num2str(exponent) '}'];
end
