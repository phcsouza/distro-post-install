#!/bin/bash

# Cores
GREEN='\033[0;32m'  # Verde
YELLOW='\033[1;33m' # Amarelo
RED='\033[0;31m'    # Vermelho
NC='\033[0m'        # Sem cor

# Flag para silenciar saídas
SILENT=0

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
sudo apt update && sudo apt upgrade -y

# Instalar nala via apt
echo -e "${YELLOW}Instalando o Nala...${NC}"
sudo apt install -y nala

# Instalar pacotes principais via nala
echo -e "${YELLOW}Instalando pacotes principais...${NC}"
sudo nala install -y curl wget vlc libreoffice btop neofetch telegram-desktop rednotebook xfce4-terminal git thunar thunderbird audacity darktable python3 python3-pip build-essential fish


#Mudar neofetch para fastfetch em distros mais atualizadas
#sudo nala fastfetch


# Instalar pacotes de pentest e suas recomendações via nala
echo -e "${YELLOW}Instalando pacotes de pentest...${NC}"
sudo nala install -y --install-recommends wifite aircrack-ng hashcat cowpatty john

# Instalar o Pacstall
echo -e "${YELLOW}Instalando o Pacstall...${NC}"
if [ $SILENT -eq 0 ]; then
  yes n | sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install || wget -q https://pacstall.dev/q/install -O -)"
else
  yes n | sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install || wget -q https://pacstall.dev/q/install -O -)" >/dev/null 2>&1
fi

# Instalar o Flatpak e adicionar o Flathub
echo -e "${YELLOW}Instalando o Flatpak e adicionando o Flathub...${NC}"
sudo nala install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Instalar pacotes via Flatpak
echo -e "${YELLOW}Instalando pacotes via Flatpak...${NC}"
flatpak install flathub com.vscodium.codium io.gitlab.librewolf-community io.github.ungoogled_software.ungoogled_chromium com.github.tchx84.Flatseal io.github.flattool.Warehouse -y

# Instalação via Git
# airgeddon
echo -e "${YELLOW}Clonando o repositório Airgeddon...${NC}"
git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git

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
alias fetch='screenfetch'
alias rpk='rhino-pkg'
alias airgeddon='cd /home/\$USER/airgeddon && sudo bash airgeddon.sh'
alias 0='clear'
" >> ~/.bashrc

# Recarregar o .bashrc para aplicar aliases no Bash
echo -e "${YELLOW}Recarregando o .bashrc...${NC}"
source ~/.bashrc

# Atualizar o sistema novamente e realizar manutenção
echo -e "${YELLOW}Atualizando o sistema novamente e realizando manutenção...${NC}"
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
sudo apt autopurge -y

# Finalizar a instalação
echo -e "${GREEN}Instalação e configurações concluídas!${NC}"
