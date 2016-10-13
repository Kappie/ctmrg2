function [C, T, convergence, N, converged] = calculate_environment(obj, temperature, chi, tolerance, initial_C, initial_T)
  C = initial_C;
  T = initial_T;
  singular_values = obj.initial_singular_values(chi);
  converged = false;

  for N = 1:obj.MAX_ITERATIONS
    singular_values_old = singular_values;
    [C, T, singular_values, truncation_error] = obj.grow_lattice(temperature, chi, C, T);
    convergence = obj.calculate_convergence(singular_values, singular_values_old, chi);

    if convergence < tolerance
      converged = true;
      break;
    end
  end

  if ~converged
    log_to_file(temperature, chi, tolerance, obj.MAX_ITERATIONS);
  end
end

function log_to_file(temperature, chi, tolerance, N)
  fileID = fopen('not_converged.log', 'a');
  fprintf(fileID, 'temperature = %f, chi = %f, tolerance = %g, max iterations = %f at %s.\n', temperature, chi, tolerance, N, datestr(now));
  fclose(fileID);
end
