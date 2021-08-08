let deferredPrompt;

// add to homescreen
window.addEventListener("beforeinstallprompt", (e) => {
  // Prevent Chrome 67 and earlier from automatically showing the prompt
  e.preventDefault();
  // Stash the event so it can be triggered later.
  deferredPrompt = e;
});

function isDeferredNotNull() {
  return deferredPrompt != null;
}

function presentAddToHome() {
  if (deferredPrompt != null) {
    // Update UI to notify the user they can add to home screen
    // Show the prompt
    deferredPrompt.prompt();
    // Wait for the user to respond to the prompt
    deferredPrompt.userChoice.then((choiceResult) => {
      if (choiceResult.outcome === "accepted") {
        console.log("User accepted the A2HS prompt");
      } else {
        console.log("User dismissed the A2HS prompt");
      }
      deferredPrompt = null;
    });
  } else {
    console.log("deferredPrompt is null");
    return null;
  }
}
