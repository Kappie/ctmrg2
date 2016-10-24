classdef MagnetizationStrip < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      transfer_matrix = ncon({T, Util.construct_a(temperature), T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      % reshape into 2chi^2 x 2chi^2 matrix
      [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);

      % Find the dominant right eigenvector, which is also the dominant
      % left eigenvector because transfer_matrix is orthogonal (why?)
      % TODO: check if the largest eigenvalue isn't degenerate.
      % global number_of_eigvals;
      % global eigenvalues;

      % opts = struct('issym', 1, 'isreal', 1);
      [eigenvectors, diagonal_matrix] = eigs(transfer_matrix, 1, 'lm');
      % [eigenvectors, diagonal_matrix] = eig(transfer_matrix);
      % diagonals = sort(diag(diagonal_matrix), 'descend');
      % diagonals = diagonals(1:number_of_eigvals);
      % eigenvalues(end+1, :) = diagonals;

      % assumption: eigenvectors is sorted (dominant eigenvector first)
      dominant_eigenvector = eigenvectors(:, 1);

      % middle column represents T - b - T, where represents summation over spin config
      % times spin eigenvalue on a site.
      middle_column = ncon({T, Util.construct_b(temperature), T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
      % reshape into 2chi^2 x 2chi^2 matrix
      [middle_column, ~, ~] = lreshape(middle_column, [1 2 3], [4 5 6]);

      % Now, this represents the unnormalized expectation value of a spin in the center of the lattice
      value = dominant_eigenvector' * middle_column * dominant_eigenvector;
      % This already has norm 1. (why?)
      % norm = dominant_eigenvector' * dominant_eigenvector
      norm = dominant_eigenvector' * transfer_matrix * dominant_eigenvector;
      value = value / norm;
    end
  end
end


function attach_environment(tensor, temperature)
% Attaches strip environment
    transfer_matrix = ncon({T, Util.construct_a(temperature), T}, {[1 -1 -4], [1 -2 2 -5], [2 -3 -6]});
    % reshape into 2chi^2 x 2chi^2 matrix
    [transfer_matrix, ~, ~] = lreshape(transfer_matrix, [1 2 3], [4 5 6]);
end
