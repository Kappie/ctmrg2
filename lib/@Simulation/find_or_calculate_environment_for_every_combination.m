function obj = find_or_calculate_environment_for_every_combination(obj, values1, values2, values3)
  obj.db_id = sqlite3.open(obj.DATABASE);

  for i1 = 1:numel(values1)
    for i2 = 1:numel(values2)
      for i3 = 1:numel(values3)
        obj.tensors(i1, i2, i3) = obj.find_or_calculate_environment(values1(i1), values2(i2), values3(i3));
      end
    end
  end

  sqlite3.close(obj.DATABASE);
end
