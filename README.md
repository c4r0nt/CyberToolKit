# CyberToolKit 🛠️

Framework de pentesting en **Bash** con menú interactivo que unifica, bajo una
sola herramienta, las tareas más habituales de una auditoría de seguridad.

Hecho por **Ane Fernández de Retana** ([@c4r0nt](https://github.com/c4r0nt)).

> ⚠️ Herramienta pensada para **entornos de laboratorio y pruebas autorizadas**.
> Úsala únicamente sobre sistemas de tu propiedad o para los que tengas permiso
> explícito.

## ¿Qué incluye?

Un menú con 7 módulos que siguen el orden natural de un pentest:

1. **Instalador de dependencias** — prepara de golpe todas las herramientas
   necesarias (nmap, john, hashcat, hashid, fping, wfuzz, exiftool, gobuster,
   Metasploit y el diccionario rockyou).
2. **Análisis de logs** — parsea registros de **Nginx** y **Apache** para
   detectar IPs sospechosas: peticiones a horas inusuales, errores 404
   repetidos, volúmenes anómalos y accesos a rutas sensibles (`/etc/`, `/var/`…),
   con exportación a fichero.
3. **Ataque de diccionario** — identifica el hash con `hashid` y lo craquea con
   **Hashcat** o **John the Ripper**, eligiendo modo/formato y diccionario.
4. **Fingerprinting** — descubre hosts activos con `fping` y escanea puertos y
   servicios con **Nmap**, incluyendo scripts NSE.
5. **Footprinting** — extrae, muestra y edita metadatos de ficheros con
   `exiftool`.
6. **Fuzzing** — descubrimiento de directorios y recursos web con **Wfuzz** o
   **Gobuster** (o una herramienta permitida a elección).
7. **Ataque con Metasploit** — asistente que busca exploits y payloads
   compatibles, genera el `.rc` y lanza `msfconsole`.

## Uso

```bash
sudo bash CyberToolKit.sh
```

Requiere ejecutarse como **root** (para instalar dependencias y usar algunas
herramientas). La primera vez, usa la opción **1** para instalar todo.

## 🔒 Nota de seguridad

Como ejercicio de revisión sobre mi propio código, corregí una **inyección de
comandos** en el módulo de fuzzing: la opción de herramienta personalizada
usaba `eval` sobre la entrada del usuario. Ahora se valida la herramienta contra
una **lista blanca** y se ejecuta mediante un array (sin `eval`), de forma que
los metacaracteres de shell (`;`, `|`, `$()`…) ya no se interpretan.

## Roadmap

- [ ] Portar módulos a Python para mayor portabilidad.
- [ ] Generar un informe final unificado en HTML/PDF.
- [ ] Modo desatendido con fichero de configuración.

## Licencia

MIT
