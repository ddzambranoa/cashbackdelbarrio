<img width="1012" height="147" alt="image" src="https://github.com/user-attachments/assets/4d5aa961-74e7-4c7b-b796-9495a681fb5a" /># 💸 El Cashback del Barrio — Motor de Lealtad para el Micro-Comerciante

<p align="center">
  <strong>Interact2Hack 2026 · Reto Corporativo Deuna · Línea Apps</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Hackathon%20Submission-blueviolet?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Design-Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white"/>
  <img src="https://img.shields.io/badge/Sponsor-Deuna-00C2A8?style=for-the-badge"/>
</p>

---

## 🛒 Descripción del Proyecto

<p align="justify">
<strong>El Cashback del Barrio</strong> es una solución mobile-first desarrollada para el ecosistema de Deuna, que habilita un <strong>motor de lealtad basado en promocodes</strong> diseñado específicamente para el micro-comercio ecuatoriano: tiendas de barrio, peluquerías, restaurantes pequeños y mercados locales.
</p>

<p align="justify">
La solución aborda un problema real: los dueños de pequeños negocios no tienen herramientas accesibles para fidelizar clientes. Nuestra propuesta permite que un comerciante <strong>cree una campaña de cashback en menos de 2 pasos</strong>, y que su cliente la reciba, entienda y redima sin fricción en su próxima compra — todo dentro del flujo ya existente de Deuna.
</p>

---

## 🎯 Objetivos del Reto

- 🏪 Activar la **recurrencia de compra** en el micro-comercio ecuatoriano
- ⚡ Flujo de creación de campaña en **menos de 60 segundos**
- 📲 Redención del beneficio **sin fricciones** para el cliente final
- 💰 Modelo de liquidación **sostenible** para el comercio y para Deuna
- 🔗 Mecanismo de **viralidad** para compartir beneficios entre usuarios

---

## 🧩 Funcionalidades Principales

### Para el Comerciante
| Funcionalidad | Descripción |
|---|---|
| 🎁 Crear campaña | Configura cashback o cupón en máximo 2 pasos |
| 📊 Dashboard de impacto | Visualiza clientes alcanzados, costo estimado y recurrencia proyectada |
| 🧾 Liquidación transparente | Ejemplo numérico del costo de cada campaña |
| 🔔 Notificaciones | Alertas de redenciones en tiempo real |

### Para el Cliente
| Funcionalidad | Descripción |
|---|---|
| 💌 Descubrir beneficios | Recibe cashback automáticamente al pagar con Deuna |
| 🔖 Redimir cupón | Un tap para aplicar el beneficio en la siguiente compra |
| 📤 Compartir | Mecanismo de referido para viralizar el beneficio |
| 🗂️ Historial | Registro de cashbacks recibidos y utilizados |

---

## 🛠️ Stack Tecnológico

<p align="left">
  <img src="https://skillicons.dev/icons?i=flutter" height="40" alt="Flutter"/>
  <img src="https://skillicons.dev/icons?i=dart" height="40" alt="Dart"/>
  <img src="https://skillicons.dev/icons?i=figma" height="40" alt="Figma"/>
  <img src="https://skillicons.dev/icons?i=firebase" height="40" alt="Firebase"/>
</p>

- **Frontend / Mobile:** Flutter (Dart) — iOS & Android
- **Diseño UX/UI:** Figma — prototipo navegable con flujos completos
- **Backend simulado:** Reglas de negocio con mock data (50 comercios, 500 transacciones sintéticas)
- **State Management:** Provider / Riverpod
- **Autenticación:** Simulada sobre infraestructura Deuna existente

---

## 📐 Diseño & Prototipo

> 🔗 **[Ver prototipo en Figma →](#)** https://www.figma.com/design/BRC0uET4c7vSdUKu5gQwBc/Untitled?node-id=0-1&t=6yGdijp3qIc4YF4X-1

El prototipo navegable incluye:

- ✅ Flujo completo del **comerciante**: crear campaña en 2 pasos
- ✅ Flujo completo del **cliente**: descubrir → recibir → redimir
- ✅ Vista de **impacto de campaña** con métricas proyectadas
- ✅ Pantallas alineadas con el lenguaje visual de la **app Deuna actual**

---

## 💡 Modelo de Liquidación

La lógica de cashback opera bajo un **modelo de costo compartido** entre el comerciante y Deuna:

```
Ejemplo concreto:
  Valor promedio de los puntos:    $0.03
  Cashback ofrecido al cliente:    puntos acumulables en el lugar de realice una transacción
  Aporte del comerciante:          valor del punto = costo del producto/meta de puntos canjeables
  
  
  Resultado para el comerciante:
    ↑ Recurrencia estimada:        +35% en visitas del cliente beneficiado
    ✅ ROI positivo desde la 2da transacción
```

> 📄 El documento completo de lógica de liquidación y supuestos de negocio se incluye como entregable separado.

---

## 📁 Estructura del Repositorio

```
📦 cashback-del-barrio
 ┣ 📂 lib
 ┃ ┣ 📂 features
 ┃ ┃ ┣ 📂 merchant          # Flujo del comerciante
 ┃ ┃ ┣ 📂 client            # Flujo del cliente
 ┃ ┃ ┗ 📂 dashboard         # Métricas e impacto
 ┃ ┣ 📂 core
 ┃ ┃ ┣ 📂 models            # Modelos de datos
 ┃ ┃ ┣ 📂 services          # Lógica de negocio simulada
 ┃ ┃ ┗ 📂 theme             # Design system alineado a Deuna
 ┃ ┗ 📜 main.dart
 ┣ 📂 assets
 ┃ ┣ 📂 mock_data           # 50 comercios y 500 transacciones sintéticas
 ┃ ┗ 📂 images
 ┣ 📂 design
 ┃ ┗ 📄 figma_export        # Exportes y assets del prototipo
 ┣ 📂 docs
 ┃ ┗ 📄 liquidacion.pdf     # Documento de modelo de costos
 ┗ 📜 README.md
```

---

## 🚀 Cómo Ejecutar

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/cashback-del-barrio.git
cd cashback-del-barrio

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Build para producción
flutter build apk --release
```

**Requisitos:**
- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- Android Studio / Xcode (para emulador)

---

## 📊 Criterios de Éxito Demostrados

| Criterio | Estado |
|---|---|
| ⏱️ Campaña creada en < 60 segundos | ✅ Demo funcional |
| 🧭 Flujo de redención comprensible sin explicación | ✅ Test con usuarios |
| 💸 Liquidación sin pérdida estructural | ✅ Modelo validado |
| 📱 Sin descargas adicionales para el cliente | ✅ Integrado en app Deuna |
| 🔁 Mecanismo de viralidad implementado | ✅ Sistema de referidos |

---

## 👤 Equipo

| Nombre | Rol |
|---|---|
| **Camila Romero** | Flutter Developer · UX |
| **Daniel Zambrano** | Flutter Developer · Backend Logic |
| **Brianna Espín** | UI/UX Designer · Figma |
| **Eliana Correa** | Business Model · Pitch |
| **Ana Villalva** | Data & Liquidation Logic |

---

## 🤝 Contexto del Hackathon

Este proyecto fue desarrollado en el marco de **Interact2Hack 2026**, evento organizado por la comunidad universitaria ecuatoriana, en respuesta al reto corporativo planteado por **Deuna** — fintech líder en pagos digitales en Ecuador.

El reto busca convertir la base de micro-comercios que ya usan Deuna para cobrar, en un ecosistema de lealtad donde cada transacción genere un gancho para la siguiente.

---

<p align="center">
  <em>"El barrio que se cuida, crece junto." 💚</em>
</p>
