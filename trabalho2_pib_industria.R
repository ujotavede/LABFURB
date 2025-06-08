# gerar_gif_pib_industria.R
# Este script deve ser executado no console interativo para gerar o GIF

library(GetBCBData)
library(tidyverse)
library(gganimate)
library(scales)

# Código da série no SGS
my.id <- c(pib_industria = 7328)

# Baixar dados a partir de 1996
series_pib <- gbcbd_get_series(
  id = my.id,
  first.date = '1996-01-01',
  last.date = Sys.Date(),
  format.data = 'long',
  use.memoise = TRUE,
  cache.path = tempdir(),
  do.parallel = FALSE
)

# Gráfico com pontos e valores
p <- ggplot(series_pib, aes(x = ref.date, y = value)) +
  geom_line(color = 'steelblue') +
  geom_point(color = 'steelblue', size = 2) +
  geom_text(aes(label = scales::label_number(accuracy = 0.1)(value)),
            vjust = -1, size = 3, color = 'black') +
  labs(
    title = 'PIB Indústria - Taxa de variação real no ano',
    subtitle = paste(min(series_pib$ref.date), 'a', max(series_pib$ref.date)),
    x = '',
    y = '% ao ano'
  ) +
  theme_minimal()

# Criar e salvar o GIF
anim <- p + transition_reveal(ref.date)
animate(anim, fps = 10, width = 800, height = 400,
        renderer = gifski_renderer("pib_industria.gif"))
