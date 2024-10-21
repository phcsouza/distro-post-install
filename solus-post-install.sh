#!/bin/bash

# Cores
GREEN='\033[0;32m'  # Verde
YELLOW='\033[1;33m' # Amarelo
RED='\033[0;31m'    # Vermelho
NC='\033[0m'        # Sem cor

# Processar argumentos
while getopts ":n" opt; do
  case ${opt} in
    n )
      SILENT=1
      ;;
    \? )
      echo -e "${RED}Uso: $0 [-n]${NC}" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Atualizar o sistema
echo -e "${YELLOW}Atualizando o sistema...${NC}"
sudo eopkg update-repo -y
sudo eopkg upgrade -y

# Instalar pacotes principais via eopkg
echo -e "${YELLOW}Instalando pacotes principais...${NC}"
sudo eopkg install -y curl wget vlc libreoffice-calc libreoffice-writer libreoffice-impress btop fastfetch telegram rednotebook xfce4-terminal git thunar thunderbird audacity darktable lmms gimp python3 fish make

# Instalar o Flatpak e adicionar o Flathub
echo -e "${YELLOW}Instalando o Flatpak e adicionando o Flathub...${NC}"
sudo eopkg install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar pacotes via Flatpak
echo -e "${YELLOW}Instalando pacotes via Flatpak...${NC}"
flatpak install flathub com.vscodium.codium io.gitlab.librewolf-community io.github.ungoogled_software.ungoogled_chromium com.github.tchx84.Flatseal io.github.flattool.Warehouse -y

# Instalação via Git
# rhino-pkg
echo -e "${YELLOW}Clonando o repositório rhino-pkg...${NC}"
git clone https://github.com/rhino-linux/rhino-pkg.git
cd rhino-pkg
echo -e "${YELLOW}Compilando rhino-pkg...${NC}"
make -j30
echo -e "${YELLOW}Instalando rhino-pkg...${NC}"
sudo install -Dm755 rhino-pkg -t /usr/bin
cd ..

# Definir o layout do teclado para ABNT2
echo -e "${YELLOW}Definindo o layout do teclado para ABNT2...${NC}"
sudo localectl set-x11-keymap br
setxkbmap -model abnt2 -layout br

# Criar aliases no .bashrc (para Bash)
echo -e "${YELLOW}Criando aliases no .bashrc...${NC}"
echo "
alias fetch='fastfetch'
alias topgrade='flatpak update -y && sudo eopkg upgrade -y'
alias rpk='rhino-pkg'
alias pkg='eopkg'
alias 0='clear'
" >> ~/.bashrc

# Recarregar o .bashrc para aplicar aliases no Bash
echo -e "${YELLOW}Recarregando o .bashrc...${NC}"
source ~/.bashrc

# Atualizar o sistema novamente e realizar manutenção
echo -e "${YELLOW}Atualizando o sistema novamente e realizando manutenção...${NC}"
sudo eopkg upgrade -y
sudo eopkg clean -y
sudo eopkg delete-cache -y
sudo eopkg remove-orphans --purge -y

# Finalizar a instalação
echo -e "${GREEN}Instalação e configurações concluídas!${NC}"
