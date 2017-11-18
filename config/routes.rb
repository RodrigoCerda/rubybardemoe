Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'ventas/periodo', to: 'ventas#periodo'
  get 'ventas/periodo/mesas', to: 'ventas#periodo_mesas'
  get 'ventas/periodo/sectores', to: 'ventas#periodo_sectores'
  get 'ventas/periodo/empleado/', to: 'ventas#periodo_empleado'
  get 'ventas/periodo/empleado/:rut', to: 'ventas#periodo_empleado_rut'
  get 'ventas/sector/empleado/', to: 'ventas#sector_empleado'
  get 'ventas/sector/empleado/:rut', to: 'ventas#sector_empleado_rut'
  get 'ventas/ranking/empleado/periodo/:periodo/posiciones/:pos', to: 'ventas#ranking_ventas_empleados'
  get 'ventas/ranking/mesas/periodo/:periodo/posiciones/:pos', to: 'ventas#ranking_ventas_mesas'
  get 'ventas/ranking/productos/periodo/:periodo/', to: 'ventas#ranking_ventas_productos'
  get 'listar/empleados', to: 'listar#empleados'
  get 'listar/proveedores', to: 'listar#proveedores'
  get 'listar/ingredientes', to: 'listar#ingredientes'
  get 'listar/productos', to: 'listar#productos'
  get 'listar/ingrediente/proveedor', to: 'listar#ingrediente_proveedor'
end
