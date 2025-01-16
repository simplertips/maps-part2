library(rnaturalearthdata)
library("rnaturalearth")
library(sf)
library(dplyr)
library(openxlsx)


lugares <- read.xlsx("Centros turisticos de Peru/Lugares_turisticos_Peru.xlsx", 1)

# Cargar el mapa de Peru con los departamentos
#peru_map <- ne_countries(scale = "medium", country = "Peru", returnclass = "sf")

# Obtener los estados de Peru
peru_states <- ne_states(country = "Peru", returnclass = "sf")

#
library(ggplot2)
library(ggrepel)

## version 1
ggplot() +
  geom_sf(data = peru_states, fill = "white", color = "black") +  # Muestra los límites de los departamenos
  geom_point(data = lugares, aes(x = Longitud, y = Latitud, shape = `Tipo.de.atraccion`), size = 3, colour = "black") + 
  geom_text_repel(data = lugares, aes(x = Longitud, y = Latitud, label = `Lugar.turistico`), 
                  size = 4, colour = "black", box.padding = 0.5, max.overlaps = 30) +
  scale_shape_manual(values = c(14, 17, 8)) + # codigos de shapes
  labs(title = "", x = "", y = "", shape = "Tipo de atracción") +
  theme_minimal() +
  theme(legend.position = "right")  # Mostrar leyenda a la derecha

## version 2
ggplot() +
  geom_sf(data = peru_states, fill = "white", color = "black") +  # Muestra los límites de los departamentos
  #Mostrar el nombre de los estados en gris
geom_sf_label(data = peru_states, aes(label = name), color = "grey", size = 3) +
  geom_point(data = lugares, aes(x = Longitud, y = Latitud, shape = `Tipo.de.atraccion`), size = 3, colour = "black") + 
  
  # Geom_text_repel con opción de mover los textos fuera del mapa (derecha o izquierda según la longitud)
  geom_text_repel(data = lugares, aes(x = Longitud, y = Latitud, label = `Lugar.turistico`), 
                  size = 4, colour = "black", box.padding = 0.5, max.overlaps = 30,
                  nudge_x = ifelse(lugares$Longitud > -75, 5, -5),  # Ajusta el nudging dependiendo de la longitud
                  nudge_y = 0,  # No mover en y, solo mover en x
                  direction = "y",  # Asegura que los textos se coloquen fuera del mapa
                  hjust = ifelse(lugares$Longitud > -75, 0, 1),  
                  # Si Longitud > -75, alinear a la izquierda (hjust = 0), si no a la derecha (hjust = 1)
                  vjust = 0.5) +  # Centramos verticalmente
  
  scale_shape_manual(values = c(14, 17, 8)) +  # 14 para cuadros, 17 para triángulos, 8 para círculos
  labs(title = "", x = "", y = "", shape = "Tipo de atracción") +
  theme_minimal() +
  theme(
    axis.text = element_blank(), # Quitar los valores de las coordenadas en los ejes
    panel.border = element_rect(color = "gray", fill = NA, size = 1),  # Agregar un marco gris
    legend.position = c(.85,.85), # Posicionar la leyenda dentro del gráfico
    legend.background = element_rect(fill = "white", color = "gray"),  # Añadir fondo blanco y borde gris a la leyenda
    #legend.title = element_blank(),  # Opcional: Quitar el título de la leyenda
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

### Exportar como png

png("Centros turisticos de Peru/Mapa_turistico_peru.png", width = 11, height = 8, units = "in", res = 300)
## version 2
ggplot() +
  geom_sf(data = peru_states, fill = "white", color = "black") +  # Muestra los límites de los departamentos
  #Mostrar el nombre de los estados en gris
  geom_sf_label(data = peru_states, aes(label = name), color = "grey", size = 3) +
  geom_point(data = lugares, aes(x = Longitud, y = Latitud, shape = `Tipo.de.atraccion`), size = 3, colour = "black") + 
  
  # Geom_text_repel con opción de mover los textos fuera del mapa (derecha o izquierda según la longitud)
  geom_text_repel(data = lugares, aes(x = Longitud, y = Latitud, label = `Lugar.turistico`), 
                  size = 4, colour = "black", box.padding = 0.5, max.overlaps = 30,
                  nudge_x = ifelse(lugares$Longitud > -75, 5, -5),  # Ajusta el nudging dependiendo de la longitud
                  nudge_y = 0,  # No mover en y, solo mover en x
                  direction = "y",  # Asegura que los textos se coloquen fuera del mapa
                  hjust = ifelse(lugares$Longitud > -75, 0, 1),  
                  # Si Longitud > -75, alinear a la izquierda (hjust = 0), si no a la derecha (hjust = 1)
                  vjust = 0.5) +  # Centramos verticalmente
  
  scale_shape_manual(values = c(14, 17, 8)) +  # 14 para cuadros, 17 para triángulos, 8 para círculos
  labs(title = "", x = "", y = "", shape = "Tipo de atracción") +
  theme_minimal() +
  theme(
    axis.text = element_blank(), # Quitar los valores de las coordenadas en los ejes
    panel.border = element_rect(color = "gray", fill = NA, size = 1),  # Agregar un marco gris
    legend.position = c(.85,.85), # Posicionar la leyenda dentro del gráfico
    legend.background = element_rect(fill = "white", color = "gray"),  # Añadir fondo blanco y borde gris a la leyenda
    #legend.title = element_blank(),  # Opcional: Quitar el título de la leyenda
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )
dev.off()
