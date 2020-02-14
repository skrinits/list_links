Hanami::Model.migration do
  change do
    alter_table :pages do
      add_unique_constraint :url
    end
  end
end
