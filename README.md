## CyberToolKit
![Bash-Scripting-brightgreen](https://user-images.githubusercontent.com/89719224/216780401-60655d5f-6804-4a3d-a9f2-3a02a1a3f9c8.svg)

❗ Using this tool in controlled environments is completely illegal without the necessary authorization.

## Como se ejecuta la herramienta?

```
cd CyberToolKit

chmod 755 cybertoolkit.sh

sudo ./cybertoolkit.sh
```
## Kit menu 

### 1) Instalador Dependencias

- Actualiza la lista de paquetes con apt update.

- Instala varias herramientas esenciales:
nmap, john, hashid, hashcat, fping, wfuzz, libimage-exiftool-perl, y toilet.

- Clona el repositorio de rockyou desde GitHub, extrae el archivo rockyou.txt en el directorio de listas de palabras (/usr/share/wordlists) y elimina el repositorio clonado.

- Descarga e instala Metasploit Framework utilizando un script desde su repositorio oficial.

### 2) Analisis de logs

- Muestra un menú para elegir entre analizar logs de Nginx, Apache, o regresar al menú principal.

## 1. Analisis de logs de Nginx

- Solicita la ruta del archivo de logs. Si no existe, muestra un mensaje de error.

- Realiza los siguientes análisis sobre los logs:
  - **IPs solicitando a horas poco habituales**: Filtra direcciones IP de solicitudes entre las 00:00 y las 06:00.
  - **IPs con errores 404**: Lista direcciones IP que han intentado acceder a recursos inexistentes.
  - **IPs con alto volumen de solicitudes (>50)**: Identifica direcciones IP con más de 50 solicitudes.
  - **IPs buscando directorios sensibles**: Busca intentos de acceso a directorios como `/etc/`, `/var/`, y `/proc/`.
  
- Ofrece guardar un informe en el archivo `archivo_log_nginx.txt`.

## 2. Analisi de logs de Apache
- Solicita la ruta del archivo de logs. Si no existe, muestra un mensaje de error.

- Realiza los mismos análisis que en los logs de Nginx, pero aplicados a los de Apache.

- Permite guardar un informe en el archivo `archivo_log_apache.txt`.

### 3) Ataque de diccionario
- Este script realiza ataques de diccionario para descifrar un hash, utilizando herramientas como **Hashcat** o **John the Ripper**.

- Solicita el hash a descifrar y permite configurar las opciones según la herramienta seleccionada.

## 1. Hascat

1. **Identificación del tipo de hash**:
   - Utiliza la herramienta `hashid` para sugerir el tipo de hash.
   
2. **Configuración del tipo de hash**:
   - Opciones predefinidas:
     - MD5 (0)
     - SHA-1 (100)
     - SHA-256 (1400)
     - NTLM (1000)
   - Opción para ingresar manualmente el código del tipo de hash.
   
3. **Selección del diccionario**:
   - Opciones predefinidas:
     - `/usr/share/wordlists/rockyou.txt`
     - `/usr/share/john/password.lst`
   - Posibilidad de ingresar la ruta de un diccionario personalizado.
   
4. **Ejecución de Hashcat**:
   - Se ejecuta con el comando `hashcat` y muestra si la contraseña ha sido descifrada o no.
   
## 2. Jonh the Ripper

1. **Selección del formato del hash**:
   - Opciones predefinidas:
     - MD5 (raw-md5)
     - NTLM (NT)
     - SHA-1 (raw-sha1)
     - SHA-256 (raw-sha256)
   - Posibilidad de ingresar un formato manualmente.
   
2. **Verificación del formato**:
   - Comprueba si el formato seleccionado es válido utilizando `john --test`.
   
3. **Selección del diccionario**:
   - Igual que en Hashcat, permite elegir entre diccionarios predefinidos o personalizados.
   
4. **Ejecución de John the Ripper**:
   - Se ejecuta con el comando `john` y muestra si la contraseña ha sido descifrada o no.

### 4) Fingerprinting
- Este script realiza un **fingerprinting** de red mediante las herramientas `fping` y `nmap`. Detecta dispositivos activos en la red y realiza escaneos básicos y avanzados sobre direcciones IP específicas.

1. **Escaneo de red con `fping`**:
   - Solicita al usuario la red objetivo (por ejemplo, `192.168.1.0/24`).
   - Opcionalmente permite ingresar atributos adicionales para personalizar el escaneo.
   - Guarda los resultados en un archivo `fping_resultado.txt`.

2. **Validación de dispositivos activos**:
   - Lista las máquinas activas detectadas en la red.
   - Solicita al usuario una IP específica para análisis detallado.

3. **Escaneo con `nmap`**:
   - Valida la IP proporcionada.
   - Realiza un escaneo básico y muestra los puertos abiertos y servicios detectados.
   - Guarda los resultados en un archivo nombrado con la IP objetivo (`<ip_objetivo>.txt`).

4. **Opcional: Scripts adicionales con `nmap`**:
   - Permite al usuario ejecutar scripts adicionales (`vuln`, `default`, etc.) sobre la IP objetivo.
   - Los resultados de los scripts se guardan en archivos adicionales (`<ip_objetivo>_<script>.txt`).

### 5) Footprinting

- El script realiza un análisis de metadatos de archivos utilizando la herramienta `exiftool`. Permite visualizar y editar metadatos en la ruta actual, una ruta específica, o en un archivo específico. Además, cuenta con opciones para gestionar los metadatos de forma interactiva.

1. **Mostrar metadatos de los archivos en la ruta actual**:
   - Analiza y muestra los metadatos de todos los archivos en la carpeta donde se ejecuta el script.

2. **Mostrar metadatos de una ruta específica**:
   - Permite al usuario ingresar una ruta específica para analizar los metadatos de los archivos presentes en ella.

3. **Mostrar metadatos de un archivo específico**:
   - Analiza y muestra los metadatos de un archivo específico ingresado por el usuario.

4. **Editar metadatos de un archivo**:
   - Permite al usuario modificar una etiqueta específica de metadatos de un archivo seleccionado.

5. **Volver al menú principal**:
   - Finaliza la ejecución del script y regresa al menú principal.
   
### 6) Fuzzing

- El script `fuzzing()` permite realizar pruebas de fuzzing en servidores web utilizando herramientas como **Wfuzz**, **Gobuster**, o cualquier otra herramienta personalizada. Es útil para descubrir rutas, archivos o directorios válidos o vulnerables en un servidor objetivo.

## 1. Realizar fuzzing con Wfuzz

- Ejecuta Wfuzz para buscar rutas en una URL objetivo usando un diccionario.
- **Entradas requeridas:**
  - URL del servidor objetivo.
  - Ruta del diccionario (opcional, por defecto: `/usr/share/wordlists/dirb/common.txt`).
-Guarda los resultados en un archivo con formato `wfuzz_resultados_<fecha>.txt`.

## 2. Realizar fuzzing con Gobuster

- Ejecuta Gobuster para buscar rutas y directorios en una URL objetivo usando un diccionario.
- **Entradas requeridas:**
  - URL del servidor objetivo.
  - Ruta del diccionario (opcional, por defecto: `/usr/share/wordlists/dirb/common.txt`).
- Guarda los resultados en un archivo con formato `gobuster_resultados_<fecha>.txt`.

## 3. Utilizar otra herramienta de fuzzing

- Permite ejecutar cualquier herramienta de fuzzing proporcionada por el usuario mediante un comando personalizado.
- **Entradas requeridas:**
  - Comando completo para la herramienta deseada.
- Guarda los resultados en un archivo con formato `custom_fuzzing_<fecha>.txt`.

## 4. Volver al menú principal

- Sale del menú de fuzzing y regresa al menú principal del script.

### 7) Ataque con Metasploit

- La función `ataque_metasploit()` permite realizar un ataque utilizando Metasploit Framework para explotar vulnerabilidades en un servicio específico de una máquina remota. La función facilita la selección de un exploit adecuado, la configuración del payload y la ejecución del ataque mediante Metasploit.

1. **Verificación de la disponibilidad de Metasploit:**
   - La función verifica si el comando `msfconsole` está disponible en el sistema. Si no está presente, muestra un mensaje de error.

2. **Entrada de datos:**
   - La función solicita al usuario que ingrese la dirección IP de la víctima (RHOST).
   - Luego, solicita el puerto objetivo (RPORT) y el nombre del servicio a atacar.

3. **Búsqueda de exploits:**
   - Utiliza el comando `msfconsole` para buscar exploits disponibles para el servicio proporcionado por el usuario.
   - Si no se encuentran exploits, se muestra un mensaje de error.

4. **Selección de exploit:**
   - El usuario puede seleccionar el exploit deseado a partir de los resultados obtenidos.
   - Si la selección es inválida, se muestra un mensaje de error.

5. **Búsqueda de payloads:**
   - Después de seleccionar el exploit, la función busca los payloads compatibles con dicho exploit.
   - Si no se encuentran payloads, se muestra un mensaje de error.

6. **Selección de payload:**
   - El usuario selecciona un payload de la lista de payloads compatibles con el exploit elegido.
   - Si la selección es inválida, se muestra un mensaje de error.

7. **Generación de archivo RC:**
   - La función genera un archivo RC con la configuración necesaria para ejecutar el ataque en Metasploit.

8. **Ejecución del ataque:**
   - La función ejecuta el exploit utilizando `msfconsole` con el archivo RC generado previamente.

9. **Limpieza:**
   - Una vez completado el ataque, la función elimina el archivo RC temporal y muestra un mensaje indicando que el ataque se ha completado.


