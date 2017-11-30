class VentasController < ApplicationController
  def periodo
    @query = "select * from ventas_periodo"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def periodo_mesas
    @query = "select * from ventas_periodo_mesa order by id_mesa asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def periodo_sectores
    @query = "select * from ventas_periodo_sector order by id_sector asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def periodo_empleado
    @query = "select * from ventas_periodo_empleado('') order by rut_empleado asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def periodo_empleado_rut
    @query = "select * from ventas_periodo_empleado('"+params[:rut]+"') order by rut_empleado asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def sector_empleado
    @query = "select * from ventas_empleado_mesa('') order by venta_total desc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def sector_empleado_rut
    @query = "select * from ventas_empleado_mesa('"+params[:rut]+"') order by id_sector asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def ranking_ventas_empleados
    @query = "select * from top_ventas_empleado('"+params[:periodo]+"',"+params[:pos]+") order by ranking asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def ranking_ventas_mesas
    @query = "select * from top_ventas_mesa('"+params[:periodo]+"',"+params[:pos]+") order by ranking asc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
  def ranking_ventas_productos
    @query = "select * from venta_productos_periodo('"+params[:periodo]+"') order by monto_total_producto desc"
    @resultado = ActiveRecord::Base.connection.execute(@query)
    render json: @resultado
  end
end
