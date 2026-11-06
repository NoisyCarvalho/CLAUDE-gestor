#!/bin/sh
# Gera o LOG.txt: todos os commits do repositório (do mais novo ao mais antigo),
# com data e hora de São Paulo e os arquivos alterados, em texto puro.
# Eventos que não viram commit (ex.: publicação recusada) ficam em eventos-manuais.txt
# e são anexados no fim. Para atualizar:  ./gerar-log.sh   e depois commit do LOG.txt.
cd "$(dirname "$0")" || exit 1
[ -f .git/shallow ] && git fetch -q --unshallow 2>/dev/null   # precisa do histórico completo

{
  echo "LOG DO REPOSITORIO - Rotina da loja"
  echo "Horarios: America/Sao_Paulo (UTC-3). Gerado em $(TZ=America/Sao_Paulo date '+%Y-%m-%d %H:%M:%S')."
  echo "Formato: DATA HORA | commit | descricao   (A = criado, M = alterado, D = apagado)"
  echo
  echo "=== COMMITS ==="
  TZ=America/Sao_Paulo git log --date=format-local:'%Y-%m-%d %H:%M:%S' \
    --format='%n%ad | %h | %s' --name-status | sed 's/^\([AMD]\)\t/    \1 /'
  if [ -f eventos-manuais.txt ]; then
    echo
    echo "=== EVENTOS FORA DO GIT (anotados a mao) ==="
    cat eventos-manuais.txt
  fi
} > LOG.txt
echo "LOG.txt atualizado ($(git rev-list --count HEAD) commits)."
