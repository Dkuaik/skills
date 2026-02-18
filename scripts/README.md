# Scripts Directory

Scripts utilitarios para automatizar tareas comunes en el repositorio de skills.

## sync-branches.sh

**Sincroniza cambios de la rama `main` a todas las ramas especializadas.**

### ¿Por Qué Existe?

Este repositorio tiene una estructura única:
- **`main`**: Skills genéricas que aplican a cualquier proyecto (React, Django, etc.)
- **`anthropic`, `fastapi`, etc.**: Ramas especializadas que toman la base de `main` y agregan skills personalizadas para esos contextos

Cuando se agregan nuevas skills a `main`, necesitas sincronizarlas a las otras ramas sin perder los cambios específicos que cada rama tiene.

### Estrategia

El script usa **cherry-pick selectivo**:
1. Identifica commits nuevos en `main` que no están en cada rama
2. Aplica (cherry-pick) esos commits a cada rama
3. Resuelve conflictos automáticamente (mantiene versión local de la rama)
4. Pushea los cambios a origin

### Instalación

```bash
# El script ya está executable
chmod +x scripts/sync-branches.sh
```

### Uso

```bash
# Ver qué se sincronizaría sin hacer cambios
./scripts/sync-branches.sh --dry-run

# Sincronizar todas las ramas (auto-detecta branches que derivan de main)
./scripts/sync-branches.sh

# Sincronizar solo branches específicas
./scripts/sync-branches.sh --branches anthropic,fastapi

# Cherry-pick local sin pushear (para revisar primero)
./scripts/sync-branches.sh --no-push

# Ver más detalles durante ejecución
./scripts/sync-branches.sh --verbose

# Mostrar help
./scripts/sync-branches.sh --help
```

### Opciones

| Opción | Descripción |
|--------|------------|
| `--dry-run` | Muestra qué haría sin hacer cambios |
| `--verbose` | Output detallado con debug info |
| `--branches NAMES` | Sincroniza solo esas branches (comma-separated) |
| `--no-push` | Cherry-picks local, no pushea a origin |
| `--help` | Muestra este help |

### Ejemplo Real

```bash
# 1. Agregaste new skill conventional-commits a main
# 2. Commiteaste y pusheaste a main
# 3. Quieres eso en las otras ramas también:

$ ./scripts/sync-branches.sh --dry-run
[DRY-RUN] Sería cherry-pick de 1 commit a anthropic
[DRY-RUN] Sería cherry-pick de 1 commit a fastapi

# Se ve bien, ejecutamos:
$ ./scripts/sync-branches.sh
✓ anthropic synced successfully
✓ fastapi synced successfully
✓ 2/2 branches synced
```

### Flujo de Trabajo Recomendado

#### Cuando Agregues Skills Nuevas a `main`:

```bash
# 1. Crear feature branch desde main
git checkout -b feat/new-skill-name

# 2. Crear skill (ej: nuevo SKILL.md en assets/)
# 3. Commitear con conventional commits
git commit -m "feat(skill): add new-skill-name"

# 4. Pushear a main
git push origin main

# 5. Sincronizar a todas las ramas
./scripts/sync-branches.sh
```

#### Cuando Modifiques Skills Específicas en Ramas:

```bash
# 1. En rama anthropic, modifica ./anthropic-skills/SKILL.md
git checkout anthropic
# ... edita archivo ...
git commit -m "feat(anthropic-skills): customize skill for anthropic"
git push

# 2. Luego en main, agregás una skill genérica:
git checkout main
# ... creas nuevo skill ...
git commit -m "feat(skill): add generic skill"
git push

# 3. Sincronizar:
./scripts/sync-branches.sh
# -> anthropic mantiene su skill customizado
# -> recibe la nueva skill genérica de main
```

### ¿Qué Pasa en Conflictos?

Si hay conflictos durante cherry-pick:
- El script intenta resolver automáticamente
- Mantiene la versión de la rama local (no sobrescribe personalizaciones)
- Si no puede resolver, marca la rama como fallida

Para resolver manualmente:

```bash
# Si el script falla, la rama quedará en estado de cherry-pick
git cherry-pick --abort  # Para comenzar de nuevo
# o
git checkout --ours .   # Mantener cambios locales
git add .
git cherry-pick --continue
```

### Logging y Debugging

```bash
# Ver commits que se sincronizarían
git log origin/main --oneline | head -5

# Ver commits en anthropic
git log origin/anthropic --oneline | head -5

# Ver diferencia entre ramas
git diff main..anthropic --name-only
```

### Limitaciones Actuales

- Auto-detecta branches que existen en `origin`
- No sincroniza si working tree tiene cambios sin commitear
- Cherry-pick puede no funcionar si hay conflictos complejos (manual resolve needed)

### Mejoras Futuras

- [ ] Detectar conflictos automáticamente y permitir resolution strategy específica
- [ ] Reporte en HTML de qué se sincronizó
- [ ] GitHub Actions workflow para auto-sync cuando hay push a main
- [ ] Rollback automático si algo falla en alguna rama

---

**Creado para mantener consistencia entre ramas mientras permite personalizaciones por proyecto.**
