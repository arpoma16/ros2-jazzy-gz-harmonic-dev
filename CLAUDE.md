# Indra workspace (ROS 2 Jazzy + Gazebo Harmonic)

Este directorio es un **workspace colcon "contenedor"**: el repo git de la raíz
(`arpoma16/ros2-jazzy-gz-harmonic-dev`) solo mantiene el entorno (devcontainer,
`run.yml` de tmuxinator, `fastdds.xml`, dependencias). El código del proyecto vive
en repos independientes dentro de las subcarpetas (cada una con su propio `.git`).

## Proyecto

AGV (robot móvil) que transporta piezas en una fábrica de satélites (Indra).
Simulación en Gazebo + RMF (open-rmf) + Nav2, con rosbridge para la HMI web.

## Paquetes que SÍ son del proyecto (hacerles seguimiento)

| Carpeta | Remote | Rol |
|---|---|---|
| `indra/` | `arpoma16/agv_llm_factory` | **Paquete principal**: mundos, launch, RMF, nodos de objetos. Ver `indra/CLAUDE.md` |
| `bcr_bot/` | `arpoma16/bcr_bot` (fork, rama `ros2`) | Robot AGV (descripción, Nav2, `nav2_factory.launch.py`) |
| `ariac_ap/` | `arpoma16/ARIAC` (rama `ariac2025`) | Workspace/mundo base ARIAC (`ariac_gz`, `/ariac_ws`) |
| `hmi_agv/` | sin git (hay `hmi_agv.tar.xz`) | HMI Qt (C++). Candidato a repo propio |
| `indra_fleet_adapter/` | `arpoma16/indra_fleet_adapter` (privado, rama `main`) | Fleet adapter + fleet manager Open-RMF ↔ Nav2 de `bcr_bot`. Ver su `README.md` e `indra/docs/RMF_ADAPTER_DESIGN.md` |
| `rmf-web/` | `mine` = `arpoma16/rmf-web` (fork, rama `jazzy`); `origin` = `open-rmf/rmf-web` | API server + dashboard de RMF. Fork al día con upstream `jazzy` + fixes de `gateway.py`/`app.py` y config `0.0.0.0`. Actualizar con `git fetch origin && git merge origin/jazzy`; push a `mine` (no a `origin`, no mandar PRs sin pedirlo). El api-server corre con `rmf-web/.venv/bin/python` (`pipenv sync -d`, nunca `pipenv install`); Node con pnpm 12. Receta: `indra/docs/RMF.md` §11 |

## Paquetes de terceros / referencia / pruebas (NO hacerles seguimiento)

Son clones de repos ajenos, usados para probar o como base de ideas futuras.
No modificar ni commitear nada ahí; no gastar tiempo revisándolos salvo que se pida.

- RMF: `rmf_demos` (dependencia real de `indra`: fleet adapter y config de TinyRobot; el mapa `factory` ya vive en `indra/maps/factory/`), `rmf_site`,
  `rmf_site_ros2`, `rmf_site_map_server`
- Robots/manipuladores: `turtlebot3`, `husarion/`, `open_manipulator_x`,
  `dynamixel_hardware_interface`, `spot_gazebo_ros2`, `box_bot`
- Otros: `IFRA_ConveyorBelt`, `IFRA_ObjectPose`, `ros2_SimRealRobotControl`, `roboticsInfrastructure`,
  `tb3_multi_robot`, `ros2-multi-robot-automap`, `gazebo-ros-actor-plugin`,
  `rosbridge_suite`, `ros2_rust`/`ros2-rust`, `theconstruct/`, `ariac_example_team`,
  `ros-jazzy-image-proc-*`, `ros2/`

Nota: `rmf_demos` y `rosbridge_suite` son de terceros pero `indra` depende de ellos
en runtime; tratarlos como solo lectura.

## Ruido que ignorar

`build/`, `install/`, `log/`, `core`, `.pnpm-store/`, `*.gv`, `*.pdf` de frames,
`web_server.log`, `log.css`, `~~`, `RMF_Materials.zip`.

## Qué se ejecuta de verdad

Detalle de dependencias directas, procesos de `run.yml` e inconsistencias: `indra/CLAUDE.md`.
Resumen: Gazebo Harmonic (`ros_gz_sim`/`ros_gz_bridge`) + `bcr_bot` (Nav2) + `rosbridge_server` +
`ObjectManager.py` + teleop del actor. La pila RMF (`rmf_*`, `rmf-web`) solo entra por `factory_rmf.launch.py`, que no está en `run.yml`: para eso está `run_rmf.yml` (tmuxinator `indra_rmf`).
El LLM vive FUERA de este workspace: `/home/grvc/work/px4/llm_planner_gcs/multiuav_gcs` (GCS con chat LLM,
repo `alvcaballero/multiuav_gui`, mantenido por el usuario) y se conecta por rosbridge. Ver `indra/CLAUDE.md › LLM`.
`hmi_agv` es otra interfaz (Qt, voz→texto con Whisper), sin LLM.

## Entorno

- Se trabaja dentro del devcontainer (`.devcontainer/`, imagen `grvc/indra`).
- Arranque completo: tmuxinator con `run.yml` (`indra_sim`). Fábrica con Open-RMF: `tmuxinator start -p run_rmf.yml` (`indra_rmf`).
- Workspace dentro del contenedor: `/ariac_ws` (`source /opt/ros/jazzy/setup.zsh && source /ariac_ws/install/setup.zsh`).
- Build típico: `colcon build --packages-select indra bcr_bot --symlink-install`.
- No ejecutar builds sin que el usuario lo pida.

## Trabajar con el contenedor (`indra_dev_container`)

El agente corre en el HOST y opera el contenedor con `docker exec`; no hace falta levantar Claude dentro.
La raíz del workspace está montada en `/ariac_ws/src/` (se edita en el host, el cambio se ve al instante en el contenedor).
Compose: `docker-compose-nv.yml` (servicio `indra_dev`, GPU NVIDIA + X11, puertos 9090/8000/8006/5173/8083).
Levantar/parar el contenedor y matar procesos es decisión del usuario: pedir permiso.

- **Ejecutar:** `docker exec indra_dev_container bash -lc '...'`. Cada llamada es una shell nueva: hay que cargar el entorno cada vez.
- **Cargar el entorno:** `/ariac_ws/install/setup.bash` está roto (referencia a `box_bot_gazebo`, que ya no existe). Usar:
  ```
  cd /ariac_ws/install; source /opt/ros/jazzy/setup.bash
  for d in */; do p=${d%/}
    if [ -f $p/share/$p/local_setup.bash ]; then source $p/share/$p/local_setup.bash
    elif [ -f $p/share/$p/package.bash ]; then source $p/share/$p/package.bash; fi
  done
  ```
  Los paquetes `ament_python` (`rmf_demos_fleet_adapter`, `indra_fleet_adapter`, ...) solo traen `package.bash`: sin la rama `elif`
  quedan fuera de `AMENT_PREFIX_PATH` y `factory_rmf.launch.py` falla con "package 'rmf_demos_fleet_adapter' not found".
- **Compilar:** solo si el usuario lo autoriza. Siempre selectivo y SIN borrar `install/`/`build/`:
  `colcon build --packages-up-to <pkgs> --symlink-install --continue-on-error`.
  `indra` exige `rmf_demos` ya compilado (por eso `--packages-up-to`) y genera al compilar el nav graph del mapa `factory` (necesita `rmf_building_map_tools`). Referencia: ~58 s para `indra bcr_bot gazebo_ros_actor_plugin conveyorbelt_gz`.
- **Comprobar un build:** leer el log (`Summary`, `Failed`, `Aborted`). El "exit code 0" de `docker exec` solo dice que el comando se ejecutó, no que colcon terminó bien.
- **Procesos largos (Gazebo, Nav2, launches):** lanzarlos en segundo plano con log en `/tmp` dentro del contenedor y consultar con llamadas puntuales.
  Para pruebas sin pantalla: `headless:=true`.
- **Limpiar al terminar:** `pkill` por patrón NO basta. Los `parameter_bridge`, `robot_state_publisher` y `republish` sobreviven al matar Gazebo y
  quedan huérfanos duplicando `/clock`, `/actor/*` y los servicios `/world/default/*` (pasó con la prueba multirobot). Antes y después de una prueba,
  listar con `ps -eo pid,etimes,args` los restos y anotar sus PIDs; matar solo con autorización del usuario y por PID exacto, sin tocar la simulación que el usuario tenga abierta.
- **Diagnóstico rápido:** `ros2 node list` (nodos duplicados = restos de otra sesión), `ros2 topic list -t`, `ros2 action list -t`.
- **DDS:** `ROS_DOMAIN_ID=0`, `rmw_fastrtps_cpp`, `fastdds.xml` con peers `172.25.0.10/11` (red `rmf_net`).
- **Logs de una sesión del agente:** `/tmp/*.log` dentro del contenedor (no persisten si se recrea).
- **Resultados verificados de pruebas** (qué arrancó y qué no): `indra/docs/RMF.md › Verificado en ejecución`.

## Dependencia del proyecto ARIAC

Indra NO es independiente de ARIAC. Se apoya en él en estos puntos (verificados):
- **Imagen base:** `.devcontainer/Dockerfile` parte de `FROM nistariac/ariac2025:latest`; el contenedor y su workspace `/ariac_ws` salen de ahí.
- **`ariac_ap/`** = tu fork (`arpoma16/ARIAC`, rama `ariac2025`). Contiene `ariac_gz` (mundos/modelos y hooks de `GZ_SIM_RESOURCE_PATH`),
  `ariac_description`, `ariac_plugins` (plugins Gazebo en C++), `ariac_setup`, `ariac_interfaces`, `ariac_db`, `robotiq_gripper_controller` y `ariac_app`.
- **Modelos del mundo:** `warehouse1` usa modelos de ARIAC (`TrolleyBox1`, `shelf`); ya resuelto (ver `indra/CLAUDE.md`).
- **ros2_control:** `indra/package.xml` declara `controller_manager`, `ros2_control` y `gz_ros2_control`, y `indra/python/controller_starter.py`
  está escrito para robots ARIAC (`inspection_robot_*`, vía `ariac_gz/launch/robot.launch.py`). Hoy está comentado en los launch.
- **Plan futuro (por el usuario):** incorporar un brazo robótico u otros elementos con movimiento para animar el mundo.
  Punto de partida natural: la infraestructura de ARIAC (descripción de robots, controladores `ros2_control`, `robotiq_gripper_controller`,
  `controller_starter.py`). Antes de diseñarlo, comprobar qué robots/modelos de `ariac_description`/`ariac_gz` sirven y si los controladores funcionan en Jazzy + Harmonic.
- **Por tanto:** cualquier cambio en `ariac_ap` afecta a `indra`; tratarlo como repo propio (es fork) pero con cuidado de no romper la base ARIAC.
  Los elementos con movimiento propios de Indra (actores animados, cintas `conveyorbelt_gz`) son otra vía, independiente de ARIAC.

## Reglas para el agente

- Cambios solo en `indra/`, `bcr_bot/`, `ariac_ap/`, `hmi_agv/`, `indra_fleet_adapter/` y los archivos de entorno de la raíz.
- Los commits de la raíz NO incluyen las carpetas con `.git` propio.
- Antes de afirmar que un paquete es "del proyecto", verificar con `git -C <dir> remote get-url origin`.
