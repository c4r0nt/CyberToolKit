#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo -e "Por favor, ejecuta este script como root."
    exit
fi

while true; do
  figlet -c "CyberToolKit" | toilet --metal -f term
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "----------------------------- \e[34m MENÚ \e[0m -----------------------------"
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "\e[34m 1. \e[0m Instaladar Dependencias"
  echo -e "\e[34m 2. \e[0m Análisis de logs"
  echo -e "\e[34m 3. \e[0m Ataque de diccionario"
  echo -e "\e[34m 4. \e[0m Fingerprinting"
  echo -e "\e[34m 5. \e[0m Footprinting"
  echo -e "\e[34m 6. \e[0m Fuzzing"
  echo -e "\e[34m 7. \e[0m Ataque con Metasploit"
  echo -e "\e[31m 8. \e[0m Salir"
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "\033[1;33mElige una opción: \e[0m"

# Función para continuar o salir
continuar_o_salir() {
  echo -e "\033[1;33m¿Deseas continuar? (s/n): \e[0m"
  read -r continuar
  if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
      echo -e "\e[31mSaliendo del script...\e[0m"
      exit 0
  fi
}

# 1. Instalador Dependencias
instalar_dependencias() {
 echo -e "${G}Instalando dependencias....${NOCOLOR}"
        apt update
        apt-get install nmap john hashid hashcat fping wfuzz libimage-exiftool-perl toilet -y
        git clone https://github.com/zacheller/rockyou.git
        tar -xzvf rockyou/rockyou.txt.tar.gz -C "/usr/share/wordlists"
        rm -rf rockyou
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb >msfinstall && chmod 755 msfinstall && ./msfinstall
        echo -e "${G}Listo!${NOCOLOR}"
        sleep 2
 }

# 2. Analisis de logs
analizar_logs() {
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "------------------------- \e[34m ANALISIS DE LOG \e[0m ----------------------"
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "\e[34mSelecciona el tipo de log a analizar:\e[0m"
  echo -e "\e[34m1. \e[0m Logs de Nginx"
  echo -e "\e[34m2. \e[0m Logs de Apache"
  echo -e "\e[31m3. \e[0m Volver al menú principal\e[0m"
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "\033[1;33mElige una opción: \e[0m"
  read -r log_option

  case $log_option in
      1)
          echo -e "\e[34m==================================================================\e[0m"
          echo -e "-------------------------- \e[34m LOG NGINX \e[0m ---------------------------"
          echo -e "\e[34m==================================================================\e[0m"
          read -p "Introduce la ruta del archivo de logs de Nginx: " log_file
          if [[ ! -f "$log_file" ]]; then
              echo -e "\e[31mEl archivo de logs no existe. Por favor verifica la ruta.\e[0m"
              return
          fi

          echo -e "\e[33m1. Direcciones IP que han intentado realizar solicitudes a horas poco habituales (00:00 - 06:00):\e[0m"
          awk '$4 ~ /:0[0-6]:/' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr

          echo -e "\e[33m2. Direcciones IP con intentos de acceso a recursos inexistentes (404):\e[0m"
          awk '$9 == 404 {print $1}' "$log_file" | sort | uniq -c | sort -nr

          echo -e "\e[33m3. Direcciones IP con alto volumen de solicitudes (>50):\e[0m"
          awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '$1 > 50'

          echo -e "\e[33m4. IPs intentando acceder a directorios sensibles (/etc/, /var/, /proc/):\e[0m"
          grep -E "/etc/|/var/|/proc/" "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr

          #Guardar archivo de logs
          echo -e "\n\e[33m¿Deseas guardar un archivo de logs? (s/n):\e[0m"
          read -r save_report
          if [[ "$save_report" == "s" || "$save_report" == "S" ]]; then
              echo -e "\e[32mGenerando archivo...\e[0m"
              {
                  echo -e "Archivo de Logs Nginx"
                  awk '$4 ~ /:0[0-6]:/' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr
                  awk '$9 == 404 {print $1}' "$log_file" | sort | uniq -c | sort -nr
                  awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '$1 > 50'
                  grep -E "/etc/|/var/|/proc/" "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr
              } > archivo_log_nginx.txt
              echo -e "\e[32mEl archivo se ha guardado como archivo_log_nginx.txt\e[0m"
          fi
          continuar_o_salir
          ;;

      2)
          echo -e "\e[34m==================================================================\e[0m"
          echo -e "----------------------- \e[34m LOGS DE APACHE \e[0m -------------------------"
          echo -e "\e[34m==================================================================\e[0m"
          read -p "Introduce la ruta del archivo de logs de Apache: " log_file
          if [[ ! -f "$log_file" ]]; then
              echo -e "\e[31mEl archivo de logs no existe. Por favor verifica la ruta.\e[0m"
              return
          fi

          echo -e "\e[33m1. Direcciones IP que han intentado realizar solicitudes a horas poco habituales (00:00 - 06:00):\e[0m"
          awk '$4 ~ /:0[0-6]:/' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr

          echo -e "\e[33m2. Direcciones IP con intentos de acceso a recursos inexistentes (404):\e[0m"
          awk '$9 == 404 {print $1}' "$log_file" | sort | uniq -c | sort -nr

          echo -e "\e[33m3. Direcciones IP con alto volumen de solicitudes (>50):\e[0m"
          awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '$1 > 50'

          echo -e "\e[33m4. IPs intentando acceder a directorios sensibles (/etc/, /var/, /proc/):\e[0m"
          grep -E "/etc/|/var/|/proc/" "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr

         #Guardar archivo de logs
          echo -e "\n\e[33m¿Deseas guardar un archivo de logs? (s/n):\e[0m"
          read -r save_report
          if [[ "$save_report" == "s" || "$save_report" == "S" ]]; then
              echo -e "\e[32mGenerando archivo...\e[0m"
              {
                  echo -e "Archivo de Logs Apache"
                  awk '$4 ~ /:0[0-6]:/' "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr
                  awk '$9 == 404 {print $1}' "$log_file" | sort | uniq -c | sort -nr
                  awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '$1 > 50'
                  grep -E "/etc/|/var/|/proc/" "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr
              } > archivo_log_apache.txt
              echo -e "\e[32mEl archivo se ha guardado como archivo_log_apache.txt\e[0m"
          fi
          continuar_o_salir
          ;;
      3)
          return
          ;;

      *)
      # Opción inválida
          echo -e "\e[31mOpción no válida.\e[0m"
          continuar_o_salir
          ;;
  esac
}

# 3. Ataque de diccionario
ataque_diccionario() {
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "-------------------- \e[34m ATAQUE DE DICCIONARIO \e[0m ---------------------"
  echo -e "\e[34m==================================================================\e[0m"
  read -p $'\033[1;33mIntroduce el hash: \033[0m' hash
  echo "$hash" > hash.txt

  echo -e "\n\033[1;34m==================================================================\033[0m"
  echo -e "\033[1;34mSelecciona la herramienta para realizar la fuerza bruta:\033[0m"
  echo -e "  \033[1;32m1.\033[0m Hashcat"
  echo -e "  \033[1;32m2.\033[0m John the Ripper"
  echo -e "\033[1;34m==================================================================\033[0m"
  read -p $'\033[1;33mOpción [1-2]: \033[0m' herramienta

  case $herramienta in
      1)
          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34m--- Configuración de Hashcat ---\033[0m"
          echo -e "\033[1;32mIdentificando el tipo de hash...\033[0m"
          hashid -m "$hash"

          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34mSelecciona el tipo de hash:\033[0m"
          echo -e "  \033[1;32m1.\033[0m MD5 (0)"
          echo -e "  \033[1;32m2.\033[0m SHA-1 (100)"
          echo -e "  \033[1;32m3.\033[0m SHA-256 (1400)"
          echo -e "  \033[1;32m4.\033[0m NTLM (1000)"
          echo -e "  \033[1;32m5.\033[0m Otro (introducir manualmente)"
          echo -e "\033[1;34m==================================================================\033[0m"
          read -p $'\033[1;33mOpción [1-5]: \033[0m' opcion_hashcat
          case $opcion_hashcat in
              1) hashcode=0 ;;
              2) hashcode=100 ;;
              3) hashcode=1400 ;;
              4) hashcode=1000 ;;
              5) read -p $'\033[1;33mIntroduce el código del tipo de hash: \033[0m' hashcode ;;
              *) echo -e "\033[1;31mOpción no válida.\033[0m"; rm -f hash.txt; return ;;
          esac

          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34mSelecciona el diccionario:\033[0m"
          echo -e "  \033[1;32m1.\033[0m /usr/share/wordlists/rockyou.txt"
          echo -e "  \033[1;32m2.\033[0m /usr/share/john/password.lst"
          echo -e "  \033[1;32m3.\033[0m Otro diccionario (introducir ruta)"
          echo -e "\033[1;34m==================================================================\033[0m"
          read -p $'\033[1;33mOpción [1-3]: \033[0m' diccionario_opcion
          case $diccionario_opcion in
              1) diccionario="/usr/share/wordlists/rockyou.txt" ;;
              2) diccionario="/usr/share/john/password.lst" ;;
              3) read -p $'\033[1;33mIntroduce la ruta completa del diccionario: \033[0m' diccionario ;;
              *) echo -e "\033[1;31mOpción no válida.\033[0m"; rm -f hash.txt; return ;;
          esac

          echo -e "\n\033[1;32mEjecutando Hashcat...\033[0m"
          hashcat -m "$hashcode" -a 0 hash.txt "$diccionario"
          # Mostramos el resultado de hashcat
          resultado=$(hashcat --show -m "$hashcode" hash.txt)

          if [[ $resultado =~ ([^:]+):([^ ]+) ]]; then
              echo -e "\033[1;32mLa contraseña ha sido descifrada: \033[1;33m${BASH_REMATCH[2]}\033[0m"
          else
              echo -e "\033[1;31mNo se pudo descifrar la contraseña.\033[0m"
          fi
          ;;

      2)
          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34m--- Configuración de John the Ripper ---\033[0m"
          echo -e "\033[1;32mListando algoritmos compatibles...\033[0m"

          # Lista de formatos compatibles de John the Ripper
          john --list=formats | column

          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34mSelecciona el formato del hash:\033[0m"
          echo -e "  \033[1;32m1.\033[0m MD5 (raw-md5)"
          echo -e "  \033[1;32m2.\033[0m NTLM (NT)"
          echo -e "  \033[1;32m3.\033[0m SHA-1 (raw-sha1)"
          echo -e "  \033[1;32m4.\033[0m SHA-256 (raw-sha256)"
          echo -e "  \033[1;32m5.\033[0m Otro (introducir manualmente)"
          echo -e "\033[1;34m==================================================================\033[0m"
          read -p $'\033[1;33mOpción [1-5]: \033[0m' opcion_john

          case $opcion_john in
              1) formato_john="raw-md5" ;;
              2) formato_john="NT" ;;
              3) formato_john="raw-sha1" ;;
              4) formato_john="raw-sha256" ;;
              5) read -p $'\033[1;33mIntroduce el formato del hash para John the Ripper (ej. raw-md5, NT, raw-sha256): \033[0m' formato_john ;;
              *) echo -e "\033[1;31mOpción no válida.\033[0m"; rm -f hash.txt; return ;;
          esac

          # Comprobación de formato
          john --test --format="$formato_john" > /dev/null 2>&1
          if [ $? -ne 0 ]; then
              echo -e "\033[1;31mEl formato de hash seleccionado no es válido. Por favor, verifica el formato.\033[0m"
              rm -f hash.txt
              return
          fi

          echo -e "\n\033[1;34m==================================================================\033[0m"
          echo -e "\033[1;34mSelecciona el diccionario:\033[0m"
          echo -e "  \033[1;32m1.\033[0m /usr/share/wordlists/rockyou.txt"
          echo -e "  \033[1;32m2.\033[0m /usr/share/john/password.lst"
          echo -e "  \033[1;32m3.\033[0m Otro diccionario (introducir ruta)"
          echo -e "\033[1;34m==================================================================\033[0m"
          read -p $'\033[1;33mOpción [1-3]: \033[0m' diccionario_opcion
          case $diccionario_opcion in
              1) diccionario="/usr/share/wordlists/rockyou.txt" ;;
              2) diccionario="/usr/share/john/password.lst" ;;
              3) read -p $'\033[1;33mIntroduce la ruta completa del diccionario: \033[0m' diccionario ;;
              *) echo -e "\033[1;31mOpción no válida.\033[0m"; rm -f hash.txt; return ;;
          esac

          echo -e "\n\033[1;32mEjecutando John the Ripper...\033[0m"
          john --wordlist="$diccionario" --format="$formato_john" hash.txt

          # Mostramos el resultado de john the ripper
          resultado=$(john --show --format="$formato_john" hash.txt)

          if [[ $resultado =~ ([^:]+):([^ ]+) ]]; then
              echo -e "\033[1;32mLa contraseña ha sido descifrada: \033[1;33m${BASH_REMATCH[2]}\033[0m"
          else
              echo -e "\033[1;31mNo se pudo descifrar la contraseña.\033[0m"
          fi
          ;;

      *)
          echo -e "\033[1;31mOpción no válida.\033[0m"
          ;;
  esac

  rm -f hash.txt
  echo -e "\n\033[1;34m==================================================================\033[0m"
  echo -e "\033[1;34m--- Proceso finalizado ---\033[0m"
  echo -e "\033[1;34m==================================================================\033[0m"
}

# 4. Fingerprinting
fingerprinting() {
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "------------------------ \e[34m FINGERPRINTING \e[0m ------------------------"
  echo -e "\e[34m==================================================================\e[0m"

  # Escaneo de red con fping texto
  echo -e "\n\033[1;34m--- Escaneo de Red con fping ---\033[0m"
  echo -e "\033[1;33mIntroduce la red para escanear (e.j. 192.168.1.0/24):\033[0m"
  read -r red

  # Atributos adicionales
  echo -e "\033[1;33mIntroduce atributos adicionales para el escaneo con fping (deja vacío para usar los predeterminados):\033[0m"
  read -r atributos

  # Ecaneo con herramineta fping
  echo -e "\033[1;32mEscaneando la red $red con fping...\033[0m"
  fping -a -g "$red" $atributos 2>/dev/null | tee fping_resultado.txt

  # Mostrar resultados
  echo -e "\033[1;33mMáquinas activas detectadas en la red:\033[0m"
  cat fping_resultado.txt

  # Escaneo con nmap de la IP objetivo texto
  echo -e "\n\033[1;34m--- Escaneo de IP con nmap ---\033[0m"
  echo -e "\033[1;33mIntroduce la IP objetivo encontrada para realizar el escaneo con nmap:\033[0m"
  read -r ip_objetivo

  # Validar la IP objetivo
  if [[ ! "$ip_objetivo" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo -e "\033[1;31mLa IP introducida no es válida. Por favor verifica.\033[0m"
      return
  fi

  # Escaneo básico con nmap y filtrado
  echo -e "\033[1;32mRealizando escaneo básico con nmap en la IP $ip_objetivo...\033[0m"
  nmap_result=$(nmap "$ip_objetivo" 2>/dev/null)
  echo -e "\033[1;33mPuertos abiertos y servicios en la IP $ip_objetivo:\033[0m"
  echo "$nmap_result" | grep "open" | tee "${ip_objetivo}.txt"

  # Guardar resultados en archivo
  echo -e "\033[1;32mLos resultados se han guardado en el archivo ${ip_objetivo}.txt.\033[0m"

  # Lanzamiento de scripts
  while true; do
      echo -e "\n\033[1;34m--- Lanzar scripts adicionales con nmap ---\033[0m"
      echo -e "\033[1;33m¿Deseas lanzar scripts adicionales con nmap? (s/n):\033[0m"
      read -r lanzar_scripts
      if [[ "$lanzar_scripts" == "s" || "$lanzar_scripts" == "S" ]]; then
          echo -e "\033[1;33mIntroduce el script que deseas usar (e.j. vuln, default, etc.):\033[0m"
          read -r script_opcion

          echo -e "\033[1;32mEjecutando script $script_opcion con nmap...\033[0m"
          nmap -sV --script="$script_opcion" "$ip_objetivo" 2>/dev/null | tee "${ip_objetivo}_${script_opcion}.txt"

          echo -e "\033[1;32mLos resultados del script se han guardado en ${ip_objetivo}_${script_opcion}.txt.\033[0m"
      else
          echo -e "\033[1;32mFinalizando el lanzamiento de scripts.\033[0m"
          break
      fi
  done

  continuar_o_salir
}

# 5. Footprinting
footprinting() {
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "------------------------- \e[34m FOOTPRINTING \e[0m --------------------------"
  echo -e "\e[34m==================================================================\e[0m"
  while true; do
      echo -e "\033[1;34m 1. \033[0m Mostrar metadatos de los ficheros en la ruta actual"
      echo -e "\033[1;34m 2. \033[0m Mostrar metadatos de una ruta específica"
      echo -e "\033[1;34m 3. \033[0m Mostrar metadatos de un fichero específico"
      echo -e "\033[1;34m 4. \033[0m Editar metadatos de un fichero"
      echo -e "\033[1;31m 5. \033[0m Volver al menú principal"
      echo -e "\033[1;34m==================================================================\033[0m"
      echo -e "\033[1;33mElige una opción: \033[0m"
      read -r sub_option

      case $sub_option in
          # Metadatos de los ficheros en la ruta actual
          1)
              echo -e "\n\e[34m--- MOSTRANDO METADATOS DE LOS FICHEROS EN LA RUTA ACTUAL ---\e[0m"
              #Sin el find da error de fichero no encontrado
              find . -maxdepth 1 -type f ! -size 0 -print | xargs exiftool 2>/dev/null || echo -e "\e[31mError: No se encontraron archivos válidos.\e[0m"
              continuar_o_salir
              ;;

          # Metadatos de una ruta específica
          2)
              echo -e "\033[1;33mIntroduce la ruta específica:\e[0m"
              read -r ruta
              if [[ -d "$ruta" ]]; then
                  echo -e "\e[32mMostrando metadatos de los archivos en la ruta: $ruta\e[0m"
                  find "$ruta" -maxdepth 1 -type f ! -size 0 -print | xargs exiftool 2>/dev/null || echo -e "\e[31mError: No se encontraron archivos válidos.\e[0m"
              else
                  echo -e "\e[31mLa ruta especificada no es válida.\e[0m"
              fi
              continuar_o_salir
              ;;

          # Metadatos de un fichero específico
          3)
              echo -e "\033[1;33mIntroduce la ruta completa del fichero:\e[0m"
              read -r archivo
              if [[ -f "$archivo" ]]; then
                  echo -e "\e[32mMostrando metadatos del archivo: $archivo\e[0m"
                  exiftool "$archivo" 2>/dev/null || echo -e "\e[31mError: No se pudo leer el archivo.\e[0m"
              else
                  echo -e "\e[31mEl archivo especificado no existe.\e[0m"
              fi
              continuar_o_salir
              ;;

          # Editar metadatos de un fichero
          4)
              echo -e "\033[1;33mIntroduce la ruta completa del fichero a editar:\e[0m"
              read -r archivo
              if [[ -f "$archivo" ]]; then
                  echo -e "\033[1;33mIntroduce la etiqueta que deseas modificar (e.j. Author):\e[0m"
                  read -r etiqueta
                  echo -e "\033[1;33mIntroduce el nuevo valor para la etiqueta $etiqueta:\e[0m"
                  read -r valor
                  exiftool -"$etiqueta"="$valor" "$archivo" 2>/dev/null
                  if [[ $? -eq 0 ]]; then
                      echo -e "\e[32mMetadatos actualizados correctamente. Nuevos valores:\e[0m"
                      exiftool "$archivo"
                  else
                      echo -e "\e[31mError: No se pudo actualizar los metadatos.\e[0m"
                  fi
              else
                  echo -e "\e[31mEl archivo especificado no existe.\e[0m"
              fi
              continuar_o_salir
              ;;

          # Volver al menú principal
          5)
              echo -e "\033[1;32mVolviendo al menú principal...\033[0m"
              break
              ;;

          *)
          # Opción inválida
              echo -e "\033[1;31mOpción no válida. Por favor selecciona una opción correcta.\033[0m"
              ;;
      esac
  done
}

# 6. Fuzzing
fuzzing() {
  echo -e "\e[34m==================================================================\e[0m"
  echo -e "---------------------------- \e[34m FUZZING \e[0m ---------------------------"
  echo -e "\e[34m==================================================================\e[0m"
  while true; do
      echo -e "\033[1;34m 1. \033[0m Realizar fuzzing con Wfuzz"
      echo -e "\033[1;34m 2. \033[0m Realizar fuzzing con Gobuster"
      echo -e "\033[1;34m 3. \033[0m Utilizar otra herramienta de fuzzing"
      echo -e "\033[1;31m 4. \033[0m Volver al menú principal"
      echo -e "\033[1;34m==================================================================\033[0m"
      echo -e "\033[1;33mElige una opción: \033[0m"
      read -r fuzz_option

      case $fuzz_option in
          1)
              # Fuzzing con Wfuzz
              echo -e "\033[1;34m--- REALIZANDO FUZZING CON WFuzz ---\033[0m"
              echo -e "\033[1;33mIntroduce la URL del servidor objetivo (e.j. http://192.168.1.1):\033[0m"
              read -r url
              if [[ -z "$url" ]]; then
                  echo -e "\033[1;31mError: La URL no puede estar vacía.\033[0m"
                  continue
              fi

              echo -e "\033[1;33mIntroduce la ruta del diccionario a utilizar (deja vacío para usar /usr/share/wordlists/dirb/common.txt):\033[0m"
              read -r diccionario
              diccionario=${diccionario:-/usr/share/wordlists/dirb/common.txt}

              # Validar que el diccionario exista
              if [[ ! -f "$diccionario" ]]; then
                  echo -e "\033[1;31mError: El diccionario especificado no existe.\033[0m"
                  continue
              fi

              # Ejecutar Wfuzz
              echo -e "\033[1;32mRealizando fuzzing con Wfuzz...\033[0m"
              archivo_resultados="wfuzz_resultados_$(date +%Y%m%d%H%M%S).txt"
              wfuzz -c -z file,"$diccionario" --hc 404 "$url/FUZZ" | tee "$archivo_resultados"

              echo -e "\033[1;32mFuzzing completado. Los resultados se han guardado en $archivo_resultados.\033[0m"
              continuar_o_salir
              ;;

          2)
              # Fuzzing con Gobuster
              echo -e "\033[1;34m--- REALIZANDO FUZZING CON GOBUSTER ---\033[0m"
              echo -e "\033[1;33mIntroduce la URL del servidor objetivo (e.j., http://192.168.1.1):\033[0m"
              read -r url
              if [[ -z "$url" ]]; then
                  echo -e "\033[1;31mError: La URL no puede estar vacía.\033[0m"
                  continue
              fi

              echo -e "\033[1;33mIntroduce la ruta del diccionario a utilizar (deja vacío para usar /usr/share/wordlists/dirb/common.txt):\033[0m"
              read -r diccionario
              diccionario=${diccionario:-/usr/share/wordlists/dirb/common.txt}

              # Validar que el diccionario exista
              if [[ ! -f "$diccionario" ]]; then
                  echo -e "\033[1;31mError: El diccionario especificado no existe.\033[0m"
                  continue
              fi

              # Ejecutar Gobuster
              echo -e "\033[1;32mRealizando fuzzing con Gobuster...\033[0m"
              archivo_resultados="gobuster_resultados_$(date +%Y%m%d%H%M%S).txt"
              gobuster dir -u "$url" -w "$diccionario" -o "$archivo_resultados"

              echo -e "\033[1;32mFuzzing completado. Los resultados se han guardado en $archivo_resultados.\033[0m"
              continuar_o_salir
              ;;

          3)
              # Otra herramienta de fuzzing
              echo -e "\033[1;34m--- UTILIZANDO OTRA HERRAMIENTA DE FUZZING ---\033[0m"
              echo -e "\033[1;33mIntroduce el comando completo para la herramienta que deseas usar (ejemplo: dirsearch -u <URL> -e php,html):\033[0m"
              read -r comando
              if [[ -z "$comando" ]]; then
                  echo -e "\033[1;31mError: El comando no puede estar vacío.\033[0m"
                  continue
              fi

              # Ejecutar comando del usuario
              archivo_resultados="custom_fuzzing_$(date +%Y%m%d%H%M%S).txt"
              echo -e "\033[1;32mEjecutando el comando personalizado...\033[0m"
              eval "$comando | tee $archivo_resultados"

              echo -e "\033[1;32mFuzzing completado. Los resultados se han guardado en $archivo_resultados.\033[0m"
              continuar_o_salir
              ;;

          4)
              # Salir al menú principal
              echo -e "\033[1;32mVolviendo al menú principal...\033[0m"
              break
              ;;

          *)
              # Opción inválida
              echo -e "\033[1;31mOpción no válida. Por favor selecciona una opción correcta.\033[0m"
              ;;
      esac
  done
}

# 7. Metasploit
ataque_metasploit() {
    echo -e "\e[34m==================================================================\e[0m"
    echo -e "-----------------------\e[34m ATAQUE METASPLOIT \e[0m -----------------------"
    echo -e "\e[34m==================================================================\e[0m"

    # Verificar si msfconsole está disponible
    if ! command -v msfconsole &> /dev/null; then
        echo -e "\033[1;31m[ERROR] msfconsole no está instalado o no está en el PATH.\033[0m"
        return
    fi

    # Solicitar la IP de la víctima
    echo -e "\033[1;33mIntroduce la dirección IP de la víctima (RHOST): \033[0m"
    read rhost
    if [[ -z "$rhost" ]]; then
        echo -e "\033[1;31m[ERROR] La dirección IP no puede estar vacía.\033[0m"
        return
    fi

    # Solicitar el puerto objetivo
    echo -e "\033[1;33mIntroduce el puerto objetivo (RPORT): \033[0m"
    read rport
    if [[ -z "$rport" || ! "$rport" =~ ^[0-9]+$ ]]; then
        echo -e "\033[1;31m[ERROR] El puerto debe ser un número válido.\033[0m"
        return
    fi

    # Solicitar el nombre del servicio
    echo -e "\033[1;33mIntroduce el nombre del servicio que deseas atacar: \033[0m"
    read service
    if [[ -z "$service" ]]; then
        echo -e "\033[1;31m[ERROR] El nombre del servicio no puede estar vacío.\033[0m"
        return
    fi

    echo -e "\033[1;32mSeleccionaste el servicio: $service\033[0m"
    echo -e "\033[1;32mBuscando exploits para el servicio $service...\033[0m"

    # Buscar exploits para el servicio
    exploits=$(msfconsole -q -x "search $service; exit" | grep -oE 'exploit/[^ ]+')
    if [ -z "$exploits" ]; then
        echo -e "\033[1;31m[ERROR] No se encontraron exploits para el servicio $service.\033[0m"
        return
    fi

    # Listar exploits encontrados
    echo -e "\033[1;32mExploits disponibles:\033[0m"
    i=1
    for exploit in $exploits; do
        echo "$i. $exploit"
        ((i++))
    done

    # Solicitar selección de exploit
    echo -e "\033[1;33mSelecciona el número del exploit que deseas usar: \033[0m"
    read exploit_num
    selected_exploit=$(echo "$exploits" | sed -n "${exploit_num}p")
    if [ -z "$selected_exploit" ]; then
        echo -e "\033[1;31m[ERROR] El exploit seleccionado no es válido.\033[0m"
        return
    fi
    echo -e "\033[1;32mUsando el exploit: $selected_exploit\033[0m"

    # Buscar payloads compatibles
    echo -e "\033[1;32mBuscando payloads compatibles...\033[0m"
    payloads=$(msfconsole -q -x "use $selected_exploit; show payloads; exit" | grep -oE 'payload/[^ ]+')
    if [ -z "$payloads" ]; then
        echo -e "\033[1;31m[ERROR] No se encontraron payloads compatibles para el exploit seleccionado.\033[0m"
        return
    fi

    # Listar payloads compatibles
    echo -e "\033[1;32mPayloads compatibles:\033[0m"
    i=1
    for payload in $payloads; do
        echo "$i. $payload"
        ((i++))
    done

    # Solicitar selección de payload
    echo -e "\033[1;33mSelecciona el número del payload que deseas usar: \033[0m"
    read payload_num
    selected_payload=$(echo "$payloads" | sed -n "${payload_num}p")
    if [ -z "$selected_payload" ]; then
        echo -e "\033[1;31m[ERROR] El payload seleccionado no es válido.\033[0m"
        return
    fi
    echo -e "\033[1;32mUsando el payload: $selected_payload\033[0m"

    # Crear archivo RC para ejecutar Metasploit
    echo -e "\033[1;32mGenerando archivo RC para Metasploit...\033[0m"
    cat << EOF > metasploit_auto.rc
use $selected_exploit
set RHOSTS $rhost
set RPORT $rport
set PAYLOAD $selected_payload
exploit
EOF

    # Ejecutar el exploit
    echo -e "\033[1;32mEjecutando exploit con Metasploit...\033[0m"
    msfconsole -r metasploit_auto.rc

    # Limpiar archivos temporales
    echo -e "\033[1;32mLimpieza de archivos temporales...\033[0m"
    rm metasploit_auto.rc

    echo -e "\033[1;32mAtaque completado.\033[0m"
}

#Llamada variable
  read -r option
  case $option in
      1) instalar_dependencias ;;
      2) analizar_logs ;;
      3) ataque_diccionario ;;
      4) fingerprinting ;;
      5) footprinting ;;
      6) fuzzing ;;
      7) ataque_metasploit ;;
      8) echo -e "\e[31mSaliendo del script...\e[0m"; exit 0 ;;
      *) echo -e "\e[31mOpción no válida.\e[0m" ;;
  esac
done


