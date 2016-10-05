function values = compute_for_every_combination(obj, quantity, temperatures, values1, values2)
  values = zeros(numel(temperatures), numel(values1), numel(values2));

  for T_index = 1:numel(temperatures)
    for i1 = 1:numel(values1)
      for i2 = 1:numel(values2)
        C = obj.tensors(T_index, i1, i2).C;
        T = obj.tensors(T_index, i1, i2).T;
        values(T_index, i1, i2) = quantity.value_at(temperatures(T_index), C, T);
      end
    end
  end

  % automatically squeeze out singleton dimensions for convenience
  values = squeeze(values);
end
