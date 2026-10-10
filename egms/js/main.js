/*INICIO DE SCRIPT GENERAL - EDGMS */

document.addEventListener('DOMContentLoaded', () => {
    inicializarSimulaciones();
    inicializarLogin();
    inicializarRegistro();
    inicializarDashboard();
});


/* INICIO DE SIMULACIONES Y PREGUNTAS*/
function inicializarSimulaciones() {
    const tarjetas = document.querySelectorAll('.tarjeta-simulacion');
    if (!tarjetas.length) return;

    tarjetas.forEach(tarjeta => {
        const respuestaCorrecta = tarjeta.getAttribute('data-correcta');
        const opciones = tarjeta.querySelectorAll('.opcion-sim');

        opciones.forEach(opcion => {
            opcion.addEventListener('click', () => {
                if (tarjeta.classList.contains('respondida')) return;
                evaluarRespuesta(opcion, respuestaCorrecta, opciones, tarjeta);
            });
        });
    });
}

function evaluarRespuesta(opcionSeleccionada, correcta, todasLasOpciones, tarjetaPadre) {
    const textoElegido = opcionSeleccionada.textContent.trim();
    const esCorrecta = textoElegido === correcta;

    if (esCorrecta) {
        aplicarEstilo(opcionSeleccionada, '#dcfce7', '#22c55e', '#15803d', 'scale(1.02)');
    } else {
        aplicarEstilo(opcionSeleccionada, '#fee2e2', '#ef4444', '#b91c1c', 'none');
        
        // Revela la respuesta correcta automáticamente
        todasLasOpciones.forEach(opt => {
            if (opt.textContent.trim() === correcta) {
                aplicarEstilo(opt, '#dcfce7', '#22c55e', '#15803d', 'none');
            }
        });
    }

    tarjetaPadre.classList.add('respondida');
}

function aplicarEstilo(elemento, fondo, borde, textoColor, transformacion) {
    elemento.style.backgroundColor = fondo;
    elemento.style.borderColor = borde;
    elemento.style.color = textoColor;
    elemento.style.transform = transformacion;
}
/* FIN DE SIMULACIONES Y PREGUNTAS */


/* INICIO DE LÓGICA DE LOGIN Y USUARIO POR DEFECTO */
function inicializarLogin() {
    const formLogin = document.getElementById('formulario-login');
    if (!formLogin) return;

    formLogin.addEventListener('submit', (e) => {
        e.preventDefault();

        const emailInput = document.getElementById('email-login').value.trim();
        const passwordInput = document.getElementById('password-login').value.trim();
        const alerta = document.getElementById('mensaje-alerta-login');

        // Credenciales institucionales por defecto
        const emailValido = "alejo@prueba.com";
        const passwordValido = "1029280";
        const nombreUsuario = "Alejo";

        // Validamos contra usuarios guardados en localStorage
        const usuariosRegistrados = JSON.parse(localStorage.getItem('usuarios_horimappsx')) || [];
        const usuarioEncontrado = usuariosRegistrados.find(u => u.email === emailInput && u.password === passwordInput);

        if ((emailInput === emailValido && passwordInput === passwordValido) || usuarioEncontrado) {
            const nombreFinal = usuarioEncontrado ? usuarioEncontrado.nombre : nombreUsuario;
            
            // Guardamos la sesión activa en el localStorage
            localStorage.setItem('sesion_activa', JSON.stringify({ nombre: nombreFinal, email: emailInput }));

            mostrarAlerta(alerta, '¡Inicio de sesión exitoso! Redirigiendo...', '#dcfce7', '#15803d');

            setTimeout(() => {
                window.location.href = 'dashboard.html';
            }, 1000);
        } else {
            mostrarAlerta(alerta, 'Correo o contraseña incorrectos.', '#fee2e2', '#b91c1c');
        }
    });
}
/* FIN DE LÓGICA DE LOGIN Y USUARIO POR DEFECTO */


/*  INICIO DE LÓGICA DE REGISTRO INMERSIVO Y VALIDACIONES */
function inicializarRegistro() {
    const formRegistro = document.getElementById('formulario-registro');
    if (!formRegistro) return;

    formRegistro.addEventListener('submit', (e) => {
        e.preventDefault();
        console.log("Formulario interceptado correctamente...");

        const nombre = document.getElementById('nombre').value.trim();
        const email = document.getElementById('email').value.trim();
        const rol = document.getElementById('rol').value;
        const curso = document.getElementById('curso').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const alerta = document.getElementById('mensaje-alerta');

        // Validación de campos obligatorios
        if (!nombre || !email || !rol || !curso || !password || !confirmPassword) {
            mostrarAlerta(alerta, 'Por favor, completa todos los campos del formulario.', '#fee2e2', '#b91c1c');
            return;
        }

        // Validación de longitud de contraseña
        if (password.length < 6) {
            mostrarAlerta(alerta, 'La contraseña debe tener al menos 6 caracteres.', '#fee2e2', '#b91c1c');
            return;
        }

        // Validación de coincidencia de contraseñas
        if (password !== confirmPassword) {
            mostrarAlerta(alerta, 'Las contraseñas no coinciden. Verifícalas.', '#fee2e2', '#b91c1c');
            return;
        }

        const nuevosUsuarios = JSON.parse(localStorage.getItem('usuarios_horimappsx')) || [];
        
        // Verificamos si el correo ya existe
        const existeUsuario = nuevosUsuarios.some(u => u.email === email);
        if (existeUsuario) {
            mostrarAlerta(alerta, 'Este correo ya está registrado en el sistema.', '#fee2e2', '#b91c1c');
            return;
        }

        // Guardamos el nuevo usuario
        nuevosUsuarios.push({ nombre, email, rol, curso, password });
        localStorage.setItem('usuarios_horimappsx', JSON.stringify(nuevosUsuarios));
        console.log("Usuario guardado en localStorage con éxito.");

        // Éxito visual
        mostrarAlerta(alerta, '¡Registro exitoso! Redirigiendo al login...', '#dcfce7', '#15803d');

        // Forzamos la redirección de manera directa
        setTimeout(() => {
            console.log("Ejecutando redirección a login...");
            window.location.replace('login.html'); // Usamos replace en lugar de href para forzar el cambio
        }, 1200);
    });
}
/* FIN DE LÓGICA DE REGISTRO INMERSIVO Y VALIDACIONES*/


/*
   INICIO DE LÓGICA DEL DASHBOARD (Protección de ruta y sesión) */
function inicializarDashboard() {
    const nombreUsuarioSpan = document.getElementById('nombre-usuario-dashboard');
    if (!nombreUsuarioSpan) return;

    // Recuperamos la sesión activa del localStorage
    const sesion = JSON.parse(localStorage.getItem('sesion_activa'));

    // Si entran al dashboard sin iniciar sesión, se redirige al login
    if (!sesion) {
        window.location.href = 'loging.html';
        return;
    }

    nombreUsuarioSpan.textContent = sesion.nombre;

    const btnCerrarSesion = document.getElementById('btn-cerrar-sesion');
    if (btnCerrarSesion) {
        btnCerrarSesion.addEventListener('click', (e) => {
            e.preventDefault();
            localStorage.removeItem('sesion_activa'); // Borramos la sesión
            window.location.href = 'loging.html';
        });
    }
}
/* FIN DE LÓGICA DEL DASHBOARD */


/*  INICIO DE FUNCIONES AUXILIARES (Alertas y utilidades) */
function mostrarAlerta(elementoAlerta, mensaje, colorFondo, colorTexto) {
    if (!elementoAlerta) return;
    elementoAlerta.style.display = 'block';
    elementoAlerta.textContent = mensaje;
    elementoAlerta.style.backgroundColor = colorFondo;
    elementoAlerta.style.color = colorTexto;
}
/* FIN DE FUNCIONES AUXILIARES */
document.addEventListener('DOMContentLoaded', () => {
    const botonesMateria = document.querySelectorAll('.btn-materia');
    const panelesMateria = document.querySelectorAll('.materia-panel');

    if (botonesMateria.length > 0) {
        botonesMateria.forEach(boton => {
            boton.addEventListener('click', () => {
                // Quitamos la clase active de todos los botones
                botonesMateria.forEach(b => b.classList.remove('active'));
                boton.classList.add('active');

                const materiaSeleccionada = boton.getAttribute('data-materia');

                // Ocultamos todos los paneles y mostramos el correspondiente
                panelesMateria.forEach(panel => {
                    if (panel.id === `panel-${materiaSeleccionada}`) {
                        panel.style.display = 'block';
                    } else {
                        panel.style.display = 'none';
                    }
                });
            });
        });
    }
});
/* FIN DE SCRIPT GENERAL - EDGMS*/