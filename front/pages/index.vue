<template>
  <div>
    <ul>
      <li v-for="property in propertyList" :key="property.id">
        {{ property.label.id }}
        <select v-model.lazy="selected" @change="contentUpdate(property.id, $event)">
          <option disabled value="">{{ property.label.status }}</option>
          <option value="0">0</option>
          <option value="1">1</option>
          <option value="2">2</option>
        </select>
        <div  v-if="modalFlag && missId==property.id">
          <Modal @close-click="closeModal"></Modal>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data:() => {
    return {
      properties: [],
      id: '',
      uid: '',
      // selected: '',
      modalFlag: false,
      missId: '',
    }
  },

  mounted() {
    this.fetchContents()
  },

  computed: {
    propertyList: function() {
      return this.properties.sort(function (a, b) {
        if(a.created_at < b.created_at) return -1
        if(a.created_at > b.created_at) return 1
      return 0
    })
    },
  //   params() {
  //     return {
  //       property: {
  //         content: this.content,
  //         // id: this.id
  //       }
  //     }
  //   }
  },

  methods: {
    async fetchContents() {
      const res_index = await this.$axios.get('/api/v1/properties').then((res) => {
        this.properties = res.data.properties
        this.selected = ""
      })
    },

    async contentUpdate(id, $event) {
      const url = `/api/v1/properties/${id}`
      const res_data = await this.$axios.get(url)
      const patch_data = res_data.data.property
      patch_data.label.status = $event.target.value
      this.$axios.patch(url, patch_data)
        .then(res => {
          this.fetchContents()
        })
        .catch((err) => {
          const id = JSON.parse(err.config.data).id
          this.openModal(id)
        })
    },

    openModal(id) {
      this.modalFlag = true
      this.missId = id
    },
    closeModal(){
      this.modalFlag = false
      this.fetchContents()
    }
  }
}
</script>
