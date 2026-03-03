# Skill: Git Commits
## Descripción
Patrones y buenas prácticas para escribir commits profesionales, atómicos y bajo el estándar de Conventional Commits.

## Principios Fundamentales (CONCEPTS > CODE)
1. **Atómico:** Un commit, una responsabilidad. NUNCA mezcles refactors de código con nuevas features o fixes en el mismo commit.
2. **El POR QUÉ, no el QUÉ:** El código ya dice *qué* hiciste. El commit debe explicar *por qué* lo hiciste, qué problema resuelve o qué lógica de negocio hay detrás.
3. **Legibilidad e Historial Lineal:** El log de Git es documentación viva. Alguien leyendo el log dentro de 3 años debería entender el estado del proyecto sin mirar el código.

## Formato Estándar (Conventional Commits)
Sigue SIEMPRE esta estructura:

```
<tipo>[scope opcional]: <descripción corta en imperativo>

[cuerpo opcional detallando el POR QUÉ y contexto]

[pie opcional con referencias a tickets, ej: Closes #123]
```

### Tipos Permitidos
* `feat`: Una nueva característica para el usuario o sistema.
* `fix`: Resolución de un bug.
* `docs`: Cambios exclusivos en la documentación.
* `style`: Cambios de formato que no afectan la lógica (espacios, punto y coma, formateo).
* `refactor`: Cambio en el código que no corrige un bug ni añade una feature, pero mejora la estructura interna.
* `perf`: Un refactor que mejora el rendimiento.
* `test`: Añadir tests faltantes o corregir tests existentes.
* `chore`: Actualización de tareas de build, configuración de paquetes, dependencias, etc.

## Reglas de Oro para la Descripción (Subject)
* **Imperativo:** Habla como si estuvieras dando una orden al código base. "add feature" (NO "added" ni "adds"). "fix bug" (NO "fixed"). Piensa en que completa la frase: "Si aplico este commit, el código va a..."
* **Límite de 50 caracteres:** Corto y al pie.
* **Sin punto final:** No uses punto al final de la primera línea.
* **Minúsculas:** Empieza la descripción en minúsculas.

## Reglas de Oro para el Cuerpo (Body)
* **Límite de 72 caracteres por línea:** Para que sea fácil de leer en la terminal.
* **Explica el motivo:** ¿Cuál era el estado anterior? ¿Qué problema causaba? ¿Cómo lo soluciona tu enfoque?
* **Alternativas:** Si tomaste una decisión arquitectónica difícil, explica por qué descartaste las otras opciones.

## Ejemplos Reales

### ❌ Mal (El "Tutorial Programmer" commit)
```
fixed the login bug and also added some padding to the button and refactored the auth service
```

### ✅ Bien (El Arquitecto Senior commit)
```
fix(auth): prevent infinite redirect loop on token expiration

The auth interceptor was failing to clear the local storage
when the refresh token endpoint returned a 401. This caused
the app to continuously retry fetching user data.

This commit clears the stale tokens and forcefully redirects
the user to the login route.

Closes #452
```

## Checklist de Autoevaluación
- [ ] ¿El commit hace una sola cosa?
- [ ] ¿Usa Conventional Commits (feat, fix, refactor, etc.)?
- [ ] ¿El subject está en imperativo y tiene menos de 50 caracteres?
- [ ] ¿El body explica el contexto y el por qué del cambio?