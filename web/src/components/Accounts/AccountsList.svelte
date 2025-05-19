<script lang="ts">
 import { accounts, translations } from "../../store/stores";
 import AccountListItem from "./AccountListItem.svelte";
 import AccountCategorySelector from "./AccountCategorySelector.svelte";
 import { onMount } from "svelte";
 import { activeTab } from "../../store/stores";
 
 let accSearch = "";
 let currentPage = 0;
 let cardsPerPage = 3;
 let selectedCategory = 'all';
 
 const orgNames = ["police", "ambulance", "ems", "sheriff", "fire", "government", "lspd", "bcso"];
 
 function isSpecialOrg(account: any) {
   if (!account.name || typeof account.name !== 'string') return false;
   const lowerName = account.name.toLowerCase();
   return orgNames.some(org => lowerName.includes(org));
 }
 
 $: filteredAccounts = $accounts && Array.isArray($accounts) 
   ? $accounts.filter(item => {
       const matchesSearch = item && item.id && typeof item.id === 'string' && 
         item.id.toLowerCase().includes((accSearch || '').toLowerCase());
       
       const specialOrg = isSpecialOrg(item);
       
       const isOrgByType = item.type && 
         (item.type.toLowerCase() === "org" || item.type.toLowerCase() === "organization");
       
       const isBusiness = !!item.creator;
       
       const isPersonal = !isOrgByType && !isBusiness && !specialOrg;
       
       let matchesCategory = false;
       
       if (selectedCategory === 'all') {
         matchesCategory = true;
       } else if (selectedCategory === 'personal') {
         matchesCategory = isPersonal;
       } else if (selectedCategory === 'business') {
         matchesCategory = isBusiness;
       } else if (selectedCategory === 'org') {
         matchesCategory = (isOrgByType || specialOrg) && !isBusiness;
       }
       
       return matchesSearch && matchesCategory;
     })
   : [];
   
 $: totalPages = Math.ceil(filteredAccounts.length / cardsPerPage);
 
 $: paginatedAccounts = filteredAccounts.slice(
   currentPage * cardsPerPage, 
   (currentPage + 1) * cardsPerPage
 );
 
 $: if (accSearch || selectedCategory) {
   currentPage = 0;
 }
 
 function nextPage() {
   if (currentPage < totalPages - 1) {
     currentPage++;
   }
 }
 
 function prevPage() {
   if (currentPage > 0) {
     currentPage--;
   }
 }
 
 function handleCategoryChange(event: CustomEvent) {
   selectedCategory = event.detail;
 }
</script>


<aside class="flex-none w-1/3 overflow-hidden flex flex-col">
  <div class="flex gap-4 items-center py-2">
    <button
      on:click={() => (activeTab.set("banking"))}
      class={`category-btn px-2 py-0.5 ${$activeTab === "banking" && "active"}`}
    >
      <div
        class="w-8 h-8 rounded-lg  flex items-center justify-center"
      >
        <i class="fas fa-paper-plane text-white"></i>
      </div>
      Transactions
    </button>
    <button
      on:click={() => (activeTab.set("invoices"))}
      class={`category-btn px-2 py-0.5 ${$activeTab === "invoices" && "active"}`}
    >
      <div
        class="w-8 h-8 rounded-lg  flex items-center justify-center"
      >
        <i class="fas fa-receipt text-white"></i>
      </div>
      Invoices
    </button>
  </div>

 <div class="mb-4">
     <AccountCategorySelector 
       selectedCategory={selectedCategory}
       on:categoryChange={handleCategoryChange}
     />
     
     <div class="relative">
         <input 
             type="text" 
             class="w-full rounded-lg border border-fleeca-border p-3 pl-10 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all" 
             placeholder={$translations.account_search || 'Search cards...'} 
             bind:value={accSearch} 
         />
         <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-fleeca-text-secondary"></i>
     </div>
 </div>
 
 <div class="overflow-y-auto flex-1 pr-2 hide-scrollbar">
     {#if filteredAccounts.length > 0}
         <div class="grid grid-cols-1 gap-4 p-2">
             {#each paginatedAccounts as account (account.id)}
                 <AccountListItem {account} />
             {/each}
         </div>
         
         {#if totalPages > 1}
             <div class="flex justify-between items-center mt-4 px-2">
                 <button 
                     aria-label="Previous page" 
                     class="pagination-btn {currentPage === 0 ? 'disabled' : ''}" 
                     on:click={prevPage}
                     disabled={currentPage === 0}
                 >
                     <i class="fas fa-chevron-left"></i>
                 </button>
                 
                 <span class="text-fleeca-text-secondary text-sm">
                     {currentPage + 1} / {totalPages}
                 </span>
                 
                 <button 
                     aria-label="Next page" 
                     class="pagination-btn {currentPage === totalPages - 1 ? 'disabled' : ''}" 
                     on:click={nextPage}
                     disabled={currentPage === totalPages - 1}
                 >
                     <i class="fas fa-chevron-right"></i>
                 </button>
             </div>
         {/if}
     {:else}
         <div class="text-center py-8 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn shadow-card">
             <div class="w-16 h-16 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-4">
                     <i class="fas fa-credit-card text-fleeca-text-secondary text-2xl"></i>
             </div>
             <h3 class="text-fleeca-text font-medium">{$translations && $translations.account_not_found ? $translations.account_not_found : 'No cards found'}</h3>
             {#if selectedCategory !== 'all'}
               <button 
                 class="mt-3 text-fleeca-green hover:text-fleeca-light-green text-sm"
                 on:click={() => selectedCategory = 'all'}
               >
                 <i class="fas fa-sync-alt mr-1"></i>
                 {$translations.show_all || 'Show all accounts'}
               </button>
             {/if}
         </div>
     {/if}
 </div>
</aside>

<style>
 .pagination-btn {
   width: 32px;
   height: 32px;
   border-radius: 50%;
   background-color: var(--fleeca-card);
   border: 1px solid var(--fleeca-border);
   color: var(--fleeca-text);
   display: flex;
   align-items: center;
   justify-content: center;
   transition: all 0.2s;
 }
 
 .pagination-btn:hover:not(.disabled) {
   background-color: var(--fleeca-hover);
   transform: scale(1.05);
 }
 
 .pagination-btn.disabled {
   opacity: 0.5;
   cursor: not-allowed;
 }

 .category-selector {
    width: 100%;
  }
  
  .category-btn {
    display: flex;
    align-items: center;
    background-color: var(--fleeca-card);
    border: 1px solid var(--fleeca-border);
    border-radius: var(--border-radius);
    color: var(--fleeca-text-secondary);
    font-size: 0.875rem;
    transition: all var(--transition-normal);
  }
  
  .category-btn:hover {
    background-color: var(--fleeca-hover);
    color: var(--fleeca-text);
  }
  
  .category-btn.active {
    background-color: var(--fleeca-green);
    border-color: var(--fleeca-dark-green);
    color: white;
  }
</style>