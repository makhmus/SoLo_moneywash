document.getElementById('start-wash').addEventListener('click', function() {
    fetch('http://SoLo_moneywash:client:StartMoneyWash',{
        method: 'POST'
    });
});