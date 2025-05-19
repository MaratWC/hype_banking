<div class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50 animate-fadeIn">
  <div class="max-w-[400px] w-full bg-fleeca-card p-8 rounded-lg shadow-card">
    <div class="flex flex-col items-center justify-center">
      <div class="relative w-24 h-24 mb-6">
        <div class="absolute inset-0 rounded-full border-4 border-fleeca-bg"></div>
        <div class="absolute inset-0 rounded-full border-4 border-transparent border-t-fleeca-green animate-spin"></div>
        <div class="absolute inset-0 flex items-center justify-center">
          <i class="fas fa-university text-fleeca-green text-2xl"></i>
        </div>
      </div>
      <h3 class="text-xl font-semibold text-fleeca-text mb-2 font-display">Processing Transaction</h3>
      <p class="text-fleeca-text-secondary text-center">Please wait while we process your request...</p>
      <div class="w-full h-1 bg-fleeca-bg rounded-full mt-6 overflow-hidden">
        <div class="h-full bg-fleeca-green animate-pulse" style="width: 100%;"></div>
      </div>
    </div>
  </div>
</div>

<style>
  @keyframes spin {
      to {
          transform: rotate(360deg);
      }
  }
  @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
  }
  .animate-fadeIn {
      animation: fadeIn 0.3s ease-in-out forwards;
  }
</style>
