function [C, T, convergence] = calculate_environment(obj, temperature, chi, N, initial_C, initial_T)
  C = initial_C;
  T = initial_T;
  singular_values = obj.initial_singular_values(chi);

  % Temporary addition
  % convergences = zeros(1, N);
  % tolerance = 1e-9;
  % hickups_in_a_row = 0;

  for iteration = 1:N
    singular_values_old = singular_values;
    [C, T, singular_values, truncation_error] = obj.grow_lattice(temperature, chi, C, T);

    % Addition to inspect tolerance behaviour
    % convergences(iteration) = obj.calculate_convergence(singular_values, singular_values_old, chi);
    % if iteration > 1
    %   difference = convergences(iteration) - convergences(iteration - 1);
    %   if difference > 0
    %     display(['we have a problem: diff = ' num2str(difference), ' iteration: ' num2str(iteration), 'convergence = ' num2str(convergences(iteration))])
    %     hickups_in_a_row = hickups_in_a_row + 1;
    %   else
    %     if hickups_in_a_row ~= 0
    %       display(['hickups in a row: ' num2str(hickups_in_a_row)])
    %     end
    %     hickups_in_a_row = 0;
    %   end
    %
    %   if convergences(iteration) < tolerance
    %     display(['reached tolerance at iteration ' num2str(iteration)]);
    %     break;
    %   end
    % end

  end

  % semilogy(1:100:N, convergences(1:100:N))

  % This does NOT belong to the temporary code and should STAY.
  convergence = obj.calculate_convergence(singular_values, singular_values_old, chi);
end
