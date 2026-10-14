/**
 * ============================================================================
 * EDUGAMESKIDS - SCRIPT PRINCIPAL UNIFICADO (main.js)
 * ============================================================================
 */

document.addEventListener("DOMContentLoaded", () => {
    console.log("EduGamesKids inicializado correctamente.");

    mostrarMensajePendiente();

    // 0. Actualizar automáticamente el nombre en todas las vistas (Navbars, Saludos, Perfil, Acudiente)
    actualizarNombreEnInterfaz();

    // 1. Formularios de registro
    vincularRegistros();

    // 2. Inicio de sesión
    vincularLogin();

    // 3. Creación de actividades del docente
    vincularCrearActividad();

    // 4. Inicialización de dashboards
    inicializarDashboards();

    // 5. Forzar la carga de la primera pregunta si existe el contenedor de opciones
    if (document.getElementById("opciones-container")) {
        cargarPregunta();
    }
});


/**
 * ============================================================================
 * GESTIÓN AUTOMÁTICA DEL NOMBRE DE USUARIO
 * Reemplaza los nombres de prueba (como Sofi) por el primer nombre activo
 * en cualquier vista (Estudiante, Acudiente, Actividades, etc.)
 * ============================================================================
 */

function actualizarNombreEnInterfaz() {
    try {
        const nombreCompleto = localStorage.getItem("usuarioActual");
        
        if (nombreCompleto) {
            // Extraer únicamente el primer nombre (ej. "Matias Alejandro" -> "Matias")
            const primerNombre = nombreCompleto.trim().split(" ")[0];
            
            // 1. Reemplazar en los contenedores del menú superior (.user-name, .user-profile, etc.)
            const elementosUserName = document.querySelectorAll(".user-name, .user-profile span");
            elementosUserName.forEach(el => {
                if (el) el.innerText = primerNombre;
            });

            // 2. Reemplazar "Sofi" o cualquier nombre estático en títulos, párrafos, dashboards de acudiente y bienvenida
            const elementosTexto = document.querySelectorAll("h1, h2, h3, p, span, .user-name");
            elementosTexto.forEach(el => {
                if (el && el.children.length === 0 && el.textContent.includes("Sofi")) {
                    el.textContent = el.textContent.replace(/Sofi/g, primerNombre);
                }
            });
        }
    } catch (error) {
        console.warn("No se pudo actualizar el nombre en la interfaz:", error);
    }
}


/**
 * ============================================================================
 * NOTIFICACIONES VISUALES
 * ============================================================================
 */

function mostrarMensaje(mensaje, tipo = "success", duracion = 1800) {
    let toast = document.getElementById("edugames-toast");

    if (!toast) {
        toast = document.createElement("div");
        toast.id = "edugames-toast";

        toast.setAttribute("role", "status");
        toast.setAttribute("aria-live", "polite");

        Object.assign(toast.style, {
            position: "fixed",
            top: "24px",
            right: "24px",
            zIndex: "99999",
            maxWidth: "min(420px, calc(100vw - 32px))",
            padding: "16px 20px",
            borderRadius: "12px",
            color: "#fff",
            fontFamily: "Arial, sans-serif",
            fontSize: "15px",
            lineHeight: "1.45",
            boxShadow: "0 8px 28px rgba(0,0,0,.2)",
            opacity: "0",
            transform: "translateY(-8px)",
            transition: "opacity .22s ease, transform .22s ease"
        });

        document.body.appendChild(toast);
    }

    toast.style.background = tipo === "error" ? "#b42318" : "#16803c";
    toast.textContent = mensaje;

    requestAnimationFrame(() => {
        toast.style.opacity = "1";
        toast.style.transform = "translateY(0)";
    });

    window.clearTimeout(toast._hideTimer);

    toast._hideTimer = window.setTimeout(() => {
        toast.style.opacity = "0";
        toast.style.transform = "translateY(-8px)";
    }, duracion);
}


/**
 * Muestra mensajes guardados para la siguiente página.
 */
function mostrarMensajePendiente() {
    try {
        const mensaje = sessionStorage.getItem("edugamesMensajePendiente");

        if (mensaje) {
            sessionStorage.removeItem("edugamesMensajePendiente");
            mostrarMensaje(mensaje, "success", 2800);
        }
    } catch (error) {
        console.warn("No se pudo mostrar el mensaje pendiente:", error);
    }
}


/**
 * Muestra una notificación y después redirige a otra página.
 */
function redirigirConMensaje(mensaje, destino, espera = 1500) {
    mostrarMensaje(mensaje, "success", espera);

    window.setTimeout(() => {
        window.location.href = destino;
    }, espera);
}


/**
 * ============================================================================
 * MÓDULO 1: REGISTRO DE USUARIOS
 * ESTUDIANTE, DOCENTE Y ACUDIENTE
 * ============================================================================
 */

function registrarYRedirigir(rol) {
    const contenedor = document.querySelector(".register-form");

    if (!contenedor) {
        alert("No se encontró el formulario de registro.");
        return;
    }

    // Validar los campos obligatorios.
    const camposObligatorios = contenedor.querySelectorAll(
        "input[required], select[required]"
    );

    for (const campo of camposObligatorios) {
        const valor = campo.value.trim();

        if (!valor) {
            alert("Por favor, completa todos los campos obligatorios.");
            campo.focus();
            return;
        }

        if (campo.type === "email" && !campo.checkValidity()) {
            alert("Por favor, ingresa un correo electrónico válido.");
            campo.focus();
            return;
        }
    }

    const emailInput = contenedor.querySelector('input[type="email"]');
    const passwordInputs = contenedor.querySelectorAll('input[type="password"]');

    if (!emailInput || passwordInputs.length < 2) {
        alert("No se encontraron los campos de correo o contraseña.");
        return;
    }

    const email = emailInput.value.trim().toLowerCase();
    const password = passwordInputs[0].value;
    const confirmPassword = passwordInputs[1].value;

    // Validar la contraseña.
    if (password.length < 6) {
        alert("La contraseña debe tener al menos 6 caracteres.");
        passwordInputs[0].focus();
        return;
    }

    // Confirmar que las contraseñas coincidan.
    if (password !== confirmPassword) {
        alert("Las contraseñas no coinciden. Por favor, revísalas.");
        passwordInputs[1].focus();
        return;
    }

    // Obtener los valores de los campos.
    const getValue = (selector) => {
        const campo = contenedor.querySelector(selector);
        return campo ? campo.value.trim() : "";
    };

    // Construir el objeto del usuario.
    const usuario = {
        nombre: getValue('[name="nombre"]') || getValue('[name="nombres"]'),
        apellidos: getValue('[name="apellidos"]'),
        documento: getValue('[name="doc-number"]'),
        email: email,
        password: password,
        rol: rol,
        curso: getValue('[name="curso"]'),
        especialidad: getValue('[name="especialidad-1"]'),
        fechaRegistro: new Date().toISOString()
    };

    try {
        const usuarios = JSON.parse(
            localStorage.getItem("usuariosRegistrados") || "[]"
        );

        if (!Array.isArray(usuarios)) {
            throw new Error("El registro guardado no tiene un formato válido.");
        }

        // Evitar registrar dos cuentas con el mismo correo.
        const correoExiste = usuarios.some(
            usuarioGuardado => (usuarioGuardado.email || "").toLowerCase() === email
        );

        if (correoExiste) {
            alert("Ese correo ya tiene una cuenta registrada. Prueba iniciar sesión.");
            return;
        }

        // Guardar el nuevo usuario.
        usuarios.push(usuario);

        localStorage.setItem("usuariosRegistrados", JSON.stringify(usuarios));
        localStorage.setItem("usuarioRegistradoEmail", email);
        localStorage.setItem("usuarioRegistradoPass", password);
        localStorage.setItem("usuarioRegistradoRol", rol);
        localStorage.setItem("usuarioActual", usuario.nombre || email.split("@")[0]);

        // Mostrar notificación y redirigir al login.
        redirigirConMensaje(
            `¡Registro de ${rol} exitoso! Serás redirigido al inicio de sesión.`,
            "login.html",
            1800
        );

    } catch (error) {
        console.error("No se pudo guardar el registro:", error);
        alert("No se pudo guardar la cuenta en este navegador. Revisa la consola.");
    }
}


/**
 * Vincular los formularios de registro.
 */
function vincularRegistros() {
    const roles = ["estudiante", "docente", "acudiente"];

    roles.forEach(rol => {
        const form = document.getElementById(`form-${rol}`);
        if (form) {
            form.addEventListener("submit", event => {
                event.preventDefault();
                registrarYRedirigir(rol);
            });
        }
    });
}


/**
 * ============================================================================
 * MÓDULO 2: INICIO DE SESIÓN
 * ============================================================================
 */

function vincularLogin() {
    const formLogin = document.getElementById("form-login") || document.querySelector(".login-form");

    if (!formLogin) return;

    formLogin.addEventListener("submit", event => {
        event.preventDefault();

        const emailInput = formLogin.querySelector('input[type="email"]');
        const passInput = formLogin.querySelector('input[type="password"]');

        if (!emailInput || !passInput) {
            alert("No se encontraron los campos del inicio de sesión.");
            return;
        }

        const email = emailInput.value.trim().toLowerCase();
        const password = passInput.value;

        if (!email || !password || !emailInput.checkValidity()) {
            alert("Por favor, ingresa un correo válido y tu contraseña.");
            return;
        }

        const tabActiva = document.querySelector(".tab-btn.active");
        const rolSeleccionado = tabActiva ? tabActiva.dataset.role : "estudiante";

        let usuario = null;

        try {
            const usuarios = JSON.parse(
                localStorage.getItem("usuariosRegistrados") || "[]"
            );

            if (Array.isArray(usuarios)) {
                usuario = usuarios.find(usuarioGuardado =>
                    (usuarioGuardado.email || "").toLowerCase() === email &&
                    usuarioGuardado.password === password &&
                    usuarioGuardado.rol === rolSeleccionado
                ) || null;
            }

        } catch (error) {
            console.error("No se pudieron leer las cuentas guardadas:", error);
        }

        if (!usuario) {
            const oldEmail = (localStorage.getItem("usuarioRegistradoEmail") || "").toLowerCase();
            const oldPassword = localStorage.getItem("usuarioRegistradoPass");
            const oldRole = localStorage.getItem("usuarioRegistradoRol");

            if (email === oldEmail && password === oldPassword && rolSeleccionado === oldRole) {
                usuario = {
                    nombre: email.split("@")[0],
                    email: email,
                    rol: oldRole
                };
            }
        }

        if (!usuario) {
            alert("No encontramos una cuenta con ese correo, contraseña y perfil. Verifica los datos o regístrate.");
            return;
        }

        // Guardar la sesión activa
        localStorage.setItem("usuarioActual", usuario.nombre || email.split("@")[0]);
        localStorage.setItem("emailActual", email);
        localStorage.setItem("rolActual", usuario.rol);

        switch (usuario.rol) {
            case "estudiante":
                redirigirConMensaje("¡Inicio de sesión exitoso! Te estamos llevando al panel de estudiante.", "dashboardEstudiante.html", 1500);
                break;
            case "acudiente":
                redirigirConMensaje("¡Inicio de sesión exitoso! Te estamos llevando al panel de acudiente.", "dashboard-acudiente.html", 1500);
                break;
            case "docente":
                alert("La cuenta es válida, pero este proyecto no contiene todavía la página dashboard-docente.html.");
                break;
            default:
                alert("El perfil de esta cuenta no es válido.");
        }
    });
}


/**
 * ============================================================================
 * MÓDULO 3: PANEL DOCENTE
 * CREACIÓN DE ACTIVIDADES
 * ============================================================================
 */

function vincularCrearActividad() {
    const formCrearActividad = document.getElementById("form-crear-actividad");
    if (!formCrearActividad) return;

    formCrearActividad.addEventListener("submit", event => {
        event.preventDefault();

        const tituloInput = document.getElementById("titulo-actividad");
        const categoriaInput = document.getElementById("categoria-actividad");
        const descInput = document.getElementById("desc-actividad");

        if (!tituloInput || !categoriaInput) return;

        const titulo = tituloInput.value.trim();
        const categoria = categoriaInput.value;
        const descripcion = descInput ? descInput.value.trim() : "";

        if (!titulo || !categoria) {
            alert("Por favor completa los campos obligatorios.");
            return;
        }

        let actividades = JSON.parse(localStorage.getItem("actividadesDocente") || "[]");

        actividades.push({
            id: Date.now(),
            titulo: titulo,
            categoria: categoria,
            descripcion: descripcion,
            fecha: new Date().toLocaleDateString()
        });

        localStorage.setItem("actividadesDocente", JSON.stringify(actividades));
        alert("¡Actividad creada con éxito!");
        event.target.reset();
        renderizarActividadesDocente();
    });
}


/**
 * ============================================================================
 * MÓDULO 4: INICIALIZACIÓN DE DASHBOARDS
 * ============================================================================
 */

function inicializarDashboards() {
    const contenedorProgresoHijo = document.getElementById("progreso-hijo-container");

    if (contenedorProgresoHijo) {
        contenedorProgresoHijo.innerHTML = `
            <div class="card-progreso" style="background: rgba(255,255,255,0.05); padding: 1.5rem; border-radius: 12px; margin-top: 1rem; border: 1px solid rgba(255,255,255,0.08);">
                <h3 style="color: #00E5FF; margin-bottom: 0.5rem;">Progreso del Estudiante</h3>
                <p><strong>Última actividad:</strong> Aventura Matemática</p>
                <p><strong>Nota promedio:</strong> <span style="color: #00E5FF; font-size: 1.2rem; font-weight: bold;">9 / 10</span></p>
            </div>
        `;
    }

    renderizarActividadesDocente();
}


/**
 * Renderizar actividades creadas por el docente.
 */
function renderizarActividadesDocente() {
    const listaContainer = document.getElementById("lista-actividades-creadas");
    if (!listaContainer) return;

    let actividades = JSON.parse(localStorage.getItem("actividadesDocente") || "[]");

    if (actividades.length === 0) {
        listaContainer.innerHTML = `<p style="color: #888;">Aún no has creado ninguna actividad.</p>`;
        return;
    }

    let html = "";
    actividades.forEach(act => {
        html += `
            <div class="actividad-item-docente" style="background: rgba(255,255,255,0.03); padding: 1rem; border-radius: 8px; margin-bottom: 0.8rem; border-left: 4px solid #00E5FF; border: 1px solid rgba(255,255,255,0.06);">
                <h4 style="color: #fff; margin-bottom: 5px;">
                    ${act.titulo} <span style="font-size: 0.8rem; color: #00E5FF;">[${act.categoria}]</span>
                </h4>
                <p style="font-size: 0.9rem; color: #ccc; margin-bottom: 5px;">
                    ${act.descripcion || "Sin descripción"}
                </p>
                <small style="color: #888;">Creado el: ${act.fecha}</small>
            </div>
        `;
    });

    listaContainer.innerHTML = html;
}


/**
 * ============================================================================
 * MÓDULO 5: MOTOR DE QUIZ Y RESULTADOS
 * ============================================================================
 */

let preguntaActual = 0;
let puntaje = 0;
let opcionSeleccionada = null;

const preguntasEduGames = [
    {
        pregunta: "¿Cuánto es 5 + 3 en tu aventura matemática?",
        opciones: ["6", "7", "8", "9"],
        correcta: 2,
        categoria: "Sumas"
    },
    {
        pregunta: "¿Cuánto es 4 x 2 en el reto de multiplicación?",
        opciones: ["6", "8", "10", "12"],
        correcta: 1,
        categoria: "Multiplicaciones"
    },
    {
        pregunta: "¿Qué color principal caracteriza la interfaz inspirada en la línea estética de Apple?",
        opciones: ["Rojo carmesí", "Turquesa vibrante (#00E5FF)", "Verde militar", "Naranja brillante"],
        correcta: 1,
        categoria: "Lógica"
    },
    {
        pregunta: "¿Cuál es el propósito principal de la plataforma EduGamesKids?",
        opciones: ["Vender artículos deportivos", "Fomentar el aprendizaje mediante la gamificación", "Ver películas de acción", "Reproducir música"],
        correcta: 1,
        categoria: "General"
    }
];


/**
 * Cargar la pregunta actual.
 */
function cargarPregunta() {
    opcionSeleccionada = null;

    if (preguntaActual < preguntasEduGames.length) {
        const q = preguntasEduGames[preguntaActual];
        const textoElem = document.getElementById("pregunta-texto");

        if (textoElem) {
            textoElem.innerText = q.pregunta;
        }

        actualizarBarraProgreso();

        let opcionesHTML = "";
        q.opciones.forEach((opcion, index) => {
            opcionesHTML += `
                <button class="opcion-btn" onclick="seleccionarOpcion(${index})" id="op-${index}" style="display: block; width: 100%; margin: 10px 0; padding: 12px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #fff; cursor: pointer; text-align: left;">
                    ${opcion}
                </button>
            `;
        });

        const container = document.getElementById("opciones-container");
        if (container) {
            container.innerHTML = opcionesHTML;
        }

    } else {
        mostrarResultadoFinal();
    }
}


/**
 * Seleccionar una opción del cuestionario.
 */
function seleccionarOpcion(index) {
    opcionSeleccionada = index;
    const botones = document.querySelectorAll(".opcion-btn");

    botones.forEach((btn, i) => {
        if (i === index) {
            btn.style.border = "2px solid #00E5FF";
            btn.style.backgroundColor = "rgba(0, 229, 255, 0.12)";
        } else {
            btn.style.border = "1px solid rgba(255, 255, 255, 0.1)";
            btn.style.backgroundColor = "rgba(255,255,255,0.05)";
        }
    });
}


/**
 * Avanzar a la siguiente pregunta.
 */
function siguientePregunta() {
    if (opcionSeleccionada === null) {
        alert("Por favor selecciona una opción antes de avanzar.");
        return;
    }

    if (opcionSeleccionada === preguntasEduGames[preguntaActual].correcta) {
        puntaje++;
    }

    preguntaActual++;
    cargarPregunta();
}


/**
 * Actualizar la barra de progreso.
 */
function actualizarBarraProgreso() {
    const barra = document.getElementById("barra-progreso");

    if (barra) {
        const porcentaje = (preguntaActual / preguntasEduGames.length) * 100;
        barra.style.width = `${porcentaje}%`;
    }
}


/**
 * Mostrar el resultado final del cuestionario.
 */
function mostrarResultadoFinal() {
    const nombreUsuario = localStorage.getItem("usuarioActual") || "Estudiante";
    const notaCalculada = Math.round((puntaje / preguntasEduGames.length) * 10);

    const quizBox = document.getElementById("quiz-container");
    const resultadoBox = document.getElementById("resultado-container");

    if (quizBox && resultadoBox) {
        quizBox.style.display = "none";

        resultadoBox.innerHTML = `
            <div class="card-resultado" style="background: rgba(255, 255, 255, 0.03); padding: 2rem; border-radius: 16px; border: 1px solid rgba(255,255,255,0.08);">
                <h2>Resultado de actividad</h2>
                <p>¡Muy bien, ${nombreUsuario}!</p>
                <div style="font-size: 3rem; color: #00E5FF; font-weight: bold; margin: 10px 0;">
                    ${notaCalculada} <span style="font-size: 1.5rem; color: #888;">/ 10</span>
                </div>
                <button onclick="reiniciarQuiz()" style="background: #ff9800; color: #fff; padding: 0.8rem 1.8rem; border: none; border-radius: 10px; cursor: pointer; font-weight: bold; margin-top: 20px;">
                    🔄 Repetir actividad
                </button>
            </div>
        `;

        resultadoBox.style.display = "block";
    }
}


/**
 * Reiniciar el cuestionario.
 */
function reiniciarQuiz() {
    preguntaActual = 0;
    puntaje = 0;
    opcionSeleccionada = null;

    const quizBox = document.getElementById("quiz-container");
    const resultadoBox = document.getElementById("resultado-container");

    if (quizBox && resultadoBox) {
        quizBox.style.display = "block";
        resultadoBox.style.display = "none";
    }

    cargarPregunta();
}