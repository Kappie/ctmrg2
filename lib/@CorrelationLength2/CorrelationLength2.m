classdef CorrelationLength2 < Quantity
  methods(Static)
    function value = value_at(temperature, ~, T)
      % % Construct T - a - T
      % transfer_matrix = ncon({T, Util.construct_a(temperature), T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      %
      % % reshape into 2chi^2 x 2chi^2 matrix
      % [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);

      % % TRY SOMETHING DIFFERENT
      % % T-a-a-T
      % transfer_matrix = ncon({T, Util.construct_a(temperature), Util.construct_a(temperature), T}, ...
      %   {[1 -1 -5], [1 -2 2 -6], [2 -3 -7 3], [3 -4 -8]});
      %
      % [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3 4], [5 6 7 8]);

      transfer_matrix = ncon({T, T}, {[1 -1 -3], [1 -2 -4]});
      size(transfer_matrix);
      transfer_matrix = lreshape(transfer_matrix, [1 2], [3 4]);
      size(transfer_matrix);



      eigenvalues = eigs(transfer_matrix, 2);
      value = 1 / log(eigenvalues(1) / eigenvalues(2));
    end
  end
end
