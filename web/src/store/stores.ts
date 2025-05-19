import type { InvoiceProps } from "src/types/invoices"
import type { PhoneDataProps } from "src/types/phone"
import { writable } from "svelte/store"

export const visibility = writable(false)
export const loading = writable(false)
export const notify = writable<
  | string
  | {
      message: string
      title?: string
      type?: "success" | "error" | "info"
    }
>("")
export const activeAccount = writable(null)
export const atm = writable(false)
export const currency = writable("USD")

export const popupDetails = writable({
  account: {},
  actionType: "",
})

export const activeTab = writable<string>("banking")

export const page = writable<string>("banking")

export const accounts = writable<any[]>([])


export const translations = writable<any>({})


export const invoices = writable<InvoiceProps[]>([
  {
    id: 1,
    invoice_id: "INV-2023-001",
    receiver_name: "Michael Thompson",
    receiver_citizenid: "MT789456",
    receiver_job: "Mechanic",
    author_name: "Los Santos Customs",
    author_citizenid: "LSC001",
    author_job: "Auto Shop",
    amount: 2500,
    total: 2750,
    vat: 10,
    note: "Vehicle Repair - Custom Paint Job and Performance Upgrades",
    item: "Auto Services",
    created_date: Math.floor(Date.now() / 1000) - 86400, // 1 day ago
    status: "pending"
  },
  {
    id: 2,
    invoice_id: "INV-2023-002",
    receiver_name: "Sarah Martinez",
    receiver_citizenid: "SM123789",
    receiver_job: "Real Estate Agent",
    author_name: "Bean Machine Coffee",
    author_citizenid: "BMC002",
    author_job: "Coffee Shop",
    amount: 150,
    total: 165,
    vat: 10,
    note: "Catering Service - Business Meeting",
    item: "Catering",
    created_date: Math.floor(Date.now() / 1000) - 43200, // 12 hours ago
    status: "paid"
  },
  {
    id: 3,
    invoice_id: "INV-2023-003",
    receiver_name: "James Wilson",
    receiver_citizenid: "JW456123",
    receiver_job: "Police Officer",
    author_name: "Premium Deluxe Motorsport",
    author_citizenid: "PDM003",
    author_job: "Car Dealer",
    amount: 35000,
    total: 38500,
    vat: 10,
    note: "Vehicle Purchase - Sports Car Model X",
    item: "Vehicle",
    created_date: Math.floor(Date.now() / 1000) - 172800, // 2 days ago
    status: "unpaid"
  },
  {
    id: 4,
    invoice_id: "INV-2023-004",
    receiver_name: "Emma Davis",
    receiver_citizenid: "ED789012",
    receiver_job: "Doctor",
    author_name: "Tool Shop",
    author_citizenid: "TS004",
    author_job: "Hardware Store",
    amount: 750,
    total: 825,
    vat: 10,
    note: "Medical Equipment Supplies",
    item: "Medical Supplies",
    created_date: Math.floor(Date.now() / 1000) - 7200, // 2 hours ago
    status: "pending"
  },
  {
    id: 5,
    invoice_id: "INV-2023-005",
    receiver_name: "Robert Chen",
    receiver_citizenid: "RC345678",
    receiver_job: "Restaurant Owner",
    author_name: "Wholesale Foods",
    author_citizenid: "WF005",
    author_job: "Food Supplier",
    amount: 4200,
    total: 4620,
    vat: 10,
    note: "Weekly Food Supply Delivery",
    item: "Food Supplies",
    created_date: Math.floor(Date.now() / 1000) - 3600, // 1 hour ago
    status: "paid"
  },
  {
    id: 6,
    invoice_id: "INV-2023-006",
    receiver_name: "Lisa Anderson",
    receiver_citizenid: "LA901234",
    receiver_job: "Lawyer",
    author_name: "Digital Solutions",
    author_citizenid: "DS006",
    author_job: "Tech Shop",
    amount: 1200,
    total: 1320,
    vat: 10,
    note: "Office Equipment - Laptop and Accessories",
    item: "Electronics",
    created_date: Math.floor(Date.now() / 1000) - 259200, // 3 days ago
    status: "paid"
  },
  {
    id: 7,
    invoice_id: "INV-2023-007",
    receiver_name: "Lisa Anderson",
    receiver_citizenid: "LA901234",
    receiver_job: "Lawyer",
    author_name: "Digital Solutions",
    author_citizenid: "DS006",
    author_job: "Tech Shop",
    amount: 1200,
    total: 1320,
    vat: 10,
    note: "Office Equipment - Laptop and Accessories",
    item: "Electronics",
    created_date: Math.floor(Date.now() / 1000) - 259200, // 3 days ago
    status: "paid"
  },
]);

export const phoneData = writable<PhoneDataProps>({
  name: '',
  balance: 0,
  invoices: []
})