$(function() {

    window.addEventListener('message', (event) => {

        data = event.data;

        if (data.toggleUI){
            toggleUI(data.toggle);
        }

    })
})

function toggleUI(toggle) {
    if (toggle) {
        $("body").fadeIn();
    } else {
        $("body").fadeOut();
    }
    return toggle
}