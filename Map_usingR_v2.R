library(leaflet)
library(htmltools)
library(dplyr)
library(openxlsx)

# Lista de lugares turísticos
lugares <- read.xlsx("Centros turisticos de Peru/Lugares_turisticos_Peru.xlsx", 1)

# Crear el mapa base
mapa <- leaflet() %>%
  addTiles() %>%  # Capa de fondo
  setView(lng = -75.015152, lat = -9.189967, zoom = 6)

# Añadir marcadores con popups personalizados
for (i in 1:nrow(lugares)) {
  # Enlace a Google Maps basado en coordenadas
  enlace_google <- paste0("https://www.google.com/maps?q=", lugares$Latitud[i], ",", lugares$Longitud[i])
  
  # Crear el contenido del popup usando HTML
  popup_content <- paste0(
    "<b>", lugares$Lugar.turistico[i], "</b><br>",
    "<b>Ranking:</b> ", lugares$Ranking[i], "<br>",
    "<b>Descripción:</b> ", lugares$Descripcion[i], "<br>",
    "<b>Actividades:</b> ", lugares$Actividades.recomendadas[i], "<br>",
    '<img src="', lugares$Imagen.url[i], '" style="width:250px;"><br>',
    '<a href="', enlace_google, '" target="_blank">Ver en Google Maps</a>'
  )
  
  # Agregar el marcador al mapa
  mapa <- mapa %>%
    addMarkers(
      lng = lugares$Longitud[i],
      lat = lugares$Latitud[i],
      popup = popup_content,
      label = lugares$Lugar.turistico[i],
      labelOptions = labelOptions(noHide = TRUE, direction = "auto")
    )
}

# Mostrar el mapa
mapa
