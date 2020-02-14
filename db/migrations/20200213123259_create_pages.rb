Hanami::Model.migration do
  change do
    create_table :pages do
      primary_key :id

      column :url,  String, null: false
      column :title,  String, null: false
      column :status, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
