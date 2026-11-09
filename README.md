# ros2-jazzy-gz-harmonic-dev

Workspace colcon "contenedor" del proyecto **Indra**: un AGV que transporta piezas en una fábrica de satélites, simulado con
ROS 2 Jazzy + Gazebo Harmonic, Open-RMF y Nav2, con rosbridge para la HMI web y el chat LLM.

Este repo solo mantiene el **entorno**: devcontainer, `docker-compose-nv.yml`, `fastdds.xml`, los `run*.yml` de tmuxinator
y las instrucciones para agentes (`CLAUDE.md`). El código vive en repos independientes, en subcarpetas con su propio `.git`
(no se versionan aquí).

## Repos del proyecto

| Carpeta | Repo | Rol |
|---|---|---|
| `indra/` | [`arpoma16/agv_llm_factory`](https://github.com/arpoma16/agv_llm_factory) | Paquete principal: mundos, mapa RMF, launch, configuración de estaciones |
| `bcr_bot/` | [`arpoma16/bcr_bot`](https://github.com/arpoma16/bcr_bot) (fork, rama `ros2`) | Robot AGV: descripción, Nav2, plataforma elevadora |
| `indra_fleet_adapter/` | [`arpoma16/indra_fleet_adapter`](https://github.com/arpoma16/indra_fleet_adapter) | Fleet adapter y supervisor Open-RMF ↔ Nav2 |
| `rmf-web/` | [`arpoma16/rmf-web`](https://github.com/arpoma16/rmf-web) (fork, rama `jazzy`) | API server y dashboard de RMF |
| `ariac_ap/` | [`arpoma16/ARIAC`](https://github.com/arpoma16/ARIAC) (fork, rama `ariac2025`) | Base ARIAC: modelos y mundo (`ariac_gz`) |
| `hmi_agv/` | sin repo | HMI Qt con voz→texto |

El resto de carpetas (`rmf_demos`, `turtlebot3`, `theconstruct`, ...) son clones de terceros para referencia o pruebas.
`rmf_demos` y `rosbridge_suite` sí son dependencias en ejecución de `indra`. La lista completa y las reglas de trabajo están en [CLAUDE.md](CLAUDE.md).

## Entorno

- La imagen base es `nistariac/ariac2025:latest` (de ahí el workspace `/ariac_ws`); ver `.devcontainer/`.
- Contenedor `indra_dev_container`, con la raíz de este repo montada en `/ariac_ws/src/`.
- DDS: `ROS_DOMAIN_ID=0`, `rmw_fastrtps_cpp`, `fastdds.xml`.

## Arranque

```bash
tmuxinator start -p run.yml       # indra_sim: 1 AGV con Nav2, sin RMF
tmuxinator start -p run_rmf.yml   # indra_rmf: fábrica con Open-RMF
```

Compilar solo cuando haga falta y de forma selectiva (dentro del contenedor, en `/ariac_ws`):

```bash
colcon build --packages-up-to indra bcr_bot --symlink-install --continue-on-error
```

## Documentación

- Plan y estado del proyecto: [`indra/docs/ROADMAP.md`](indra/docs/ROADMAP.md) y [`indra/docs/ESTADO.md`](indra/docs/ESTADO.md).
- Índice de documentación: [`indra/docs/README.md`](indra/docs/README.md).
