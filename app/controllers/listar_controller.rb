class ListarController < ApplicationController
  def empleados
    @query = "select * from Lista_empleados()"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def proveedores
    @query = "select * from Lista_proveedores()"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def ingredientes
    @query = "select * from Lista_ingredientes()"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def productos
    @query = "select * from Lista_productos()"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def ingrediente_proveedor
    @query = "select * from Lista_ingrediente_proveedor()"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
end
