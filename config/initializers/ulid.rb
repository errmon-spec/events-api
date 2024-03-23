# frozen_string_literal: true

module ErrmonPostgres
  class ULID < ActiveRecord::Type::Text
    def type
      :ulid
    end
  end

  module PostgreSQLAdapterPatch
    def initialize_type_map(type_map)
      type_map.register_type 'ulid', ULID.new
      super
    end
  end

  module TableDefinitionPatch
    def ulid(name, **)
      column(name, :ulid, **)
    end
  end
end

ActiveSupport.on_load(:active_record_postgresqladapter) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:ulid] = { name: 'ulid' }

  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.singleton_class.prepend(ErrmonPostgres::PostgreSQLAdapterPatch)
  ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.prepend(ErrmonPostgres::TableDefinitionPatch)

  ActiveRecord::Type.register(:ulid, ErrmonPostgres::ULID, adapter: :postgresql)
end
